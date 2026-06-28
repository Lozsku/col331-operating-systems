#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "proc.h"
#include "x86.h"
#include "fs.h"
#include "sleeplock.h"
#include "buf.h"
#include "file.h"
#include "stat.h"
#include "cow.h"

#define NSWAP (SWAPBLOCKS / 8)

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct swapslot{
    int page_perm;
    int is_free;
    struct rmap_node rmap_node;
};

struct swapslot swapslots[NSWAP];

// walkpgdir from vm.c
pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void swapinit() {
    for (int i = 0; i < NSWAP; i++){
        struct swapslot *slot = &swapslots[i];
        slot->is_free = 1;
        slot->page_perm = 0;
        pde_t **pgdirs = slot->rmap_node.pgdirs;
        for (int j=0; j<NPROC; j++) pgdirs[j] = 0;
    }
}

struct proc* get_victim_process() {
    struct proc *victim = 0;
    uint max_rss = 0;
    acquire(&ptable.lock);
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED) continue;
        if(p->rss >= max_rss){
            if (victim != 0)
                if ((p->rss == max_rss) && (p->pid > victim->pid)) continue;
            max_rss = p->rss;
            victim = p;
        }
    }
    release(&ptable.lock);
    return victim;
}

void write_page_to_slot(char *pg, uint blk) {
    struct buf* bp;
    for(uint i=0; i<8; i++){
        bp = bread(ROOTDEV, blk+i);
        memmove(bp->data, pg+i*512, 512);
        bp->flags |= B_DIRTY;
        bwrite(bp);
        brelse(bp);
    }
}

uint find_slot(uint pa, uint perm) {
    uint free_slot = -1;
    for (int i = 0; i < NSWAP; i++){
        if (swapslots[i].is_free){
            free_slot = i;
            break;
        }
    }
    if (free_slot == -1){
        panic("No free swap slot available");
    }

    swapslots[free_slot].is_free = 0;
    swapslots[free_slot].page_perm = perm;
    uint num_pgdirs = rmap_getcnt(pa);
    for (int i=0; i<num_pgdirs; i++){
      swapslots[free_slot].rmap_node.pgdirs[i] = rmap_get(pa, i);
    }

    return free_slot;
}

int check_present_and_accessed_bits(uint page_addr, uint va){
  uint num_pgdirs = rmap_getcnt(page_addr);
  if (num_pgdirs == 0) return 0;
  for (int i=0; i<num_pgdirs; i++){
    pde_t *cur_pgdir = rmap_get(page_addr, i);
    pte_t *cur_pte = walkpgdir(cur_pgdir, (char*) va, 0); 
    if ((*cur_pte & PTE_P) && ((*cur_pte & PTE_A) == 0)){
      return 0;
    }
  }
  return 1;
}

void get_victim_page(struct proc *victim_process, uint *page_addr, uint *va) {
    pde_t *pgdir = victim_process->pgdir;
    for (int i = 0; i < NPDENTRIES; i++){
        if ((pgdir[i] & PTE_P) == 0) continue;
        pte_t *pgtable = (pte_t*)P2V(PTE_ADDR(pgdir[i]));
        for (int j = NPTENTRIES; j >= 0; j--){
            pte_t* pte = &pgtable[j];
            uint pa = PTE_ADDR(*pte);
            if (i==0 && j==0) continue;
            if (pa == 0 || PGADDR(i, j, 0) >= victim_process->sz) continue;
            if (check_present_and_accessed_bits(pa, PGADDR(i, j, 0))){
              *page_addr = pa;
              *va = PGADDR(i, j, 0);
              return;
            }        
        }
    }
    return;
}

uint clear_accessed_bits_from_pa(uint page_addr, uint va){
  uint num_pgdirs = rmap_getcnt(page_addr);
  uint count = 0;
  for (int i=0; i<num_pgdirs; i++){
    pde_t *cur_pgdir = rmap_get(page_addr, i);
    pte_t *cur_pte = walkpgdir(cur_pgdir, (char*) va, 0); 
    
    if ((*cur_pte & PTE_P) && (*cur_pte & PTE_A)){
      *cur_pte &= ~PTE_A;
      count = 1;
    }
  }
  return count;
}

void clear_accessed_bits(struct proc *victim_process) {
    int count = 0;
    pde_t *pgdir = victim_process->pgdir;

    for (uint i = 0; i < NPDENTRIES; i++){
        if ((pgdir[i] & PTE_P) == 0) continue;
        pte_t *pgtable = (pte_t*)P2V(PTE_ADDR(pgdir[i]));
        for (uint j = 0; j < NPTENTRIES; j++){
            pte_t* pte = &pgtable[j];
            if (i==0 && j==0) continue;
            if (PTE_ADDR(*pte) == 0 || PGADDR(i, j, 0) >= victim_process->sz) continue;

            if (clear_accessed_bits_from_pa(PTE_ADDR(*pte), PGADDR(i, j, 0))) count += 1;

            if (count >= ((victim_process->sz)/PGSIZE) * 0.1){
                return;
            }

        }
    }
}


void write_slotnums_to_ptes(uint page_addr, uint va, uint slot_num){
  uint num_pgdirs = rmap_getcnt(page_addr);
  for (uint i=0; i<num_pgdirs; i++){
    pde_t *cur_pgdir = rmap_get(page_addr, i);
    pte_t *cur_pte = walkpgdir(cur_pgdir, (char*) va, 0); 

    *cur_pte = (slot_num << 12);
    lcr3(V2P(cur_pgdir));

    acquire(&ptable.lock);
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->pgdir != cur_pgdir) continue;
      p->rss -= 4096;    
      break;
    }
    release(&ptable.lock);
  }
}

char* swap_out() {
    struct proc *victim_process = get_victim_process();
    uint victim_page_pa = 0, va;
    get_victim_page(victim_process, &victim_page_pa, &va);
    while (victim_page_pa == 0){
        clear_accessed_bits(victim_process);
        get_victim_page(victim_process, &victim_page_pa, &va);
    }
    uint slot_num = find_slot(victim_page_pa, PTE_P | PTE_W | PTE_U);
    write_slotnums_to_ptes(victim_page_pa, va, slot_num);
    write_page_to_slot((char*)P2V(victim_page_pa), 2+slot_num*8);
    rmap_clear_addr(victim_page_pa);
    return (char*)P2V(victim_page_pa);
}

void swap_in(uint va, pde_t *pgdir) {
  va = PGROUNDDOWN(va);
  pde_t *pte = walkpgdir(pgdir, (char*) va, 0);   
  if (*pte & PTE_P){
    if ((~(*pte)) & PTE_W){
        rmap_pgflt(va, pgdir);
    }
    return;
  }
  uint slotnum = (*pte) >> 12;
  char *newpg = kalloc();
  for (uint i=0; i<8; i++){
    struct buf* bp = bread(ROOTDEV, 2+slotnum*8+i);
    memmove(newpg+512*i, bp->data, 512);
    brelse(bp);
  }


  pde_t **pgdirs = swapslots[slotnum].rmap_node.pgdirs;
  for (int i=0; i<NPROC; i++){
    pde_t *cur_pdir = pgdirs[i];
    if (cur_pdir == 0) break;
    pde_t *cur_pte = walkpgdir(cur_pdir, (char*) va, 0);   
    *cur_pte = V2P(newpg) | swapslots[slotnum].page_perm;
    lcr3(V2P(cur_pdir));

    acquire(&ptable.lock);
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->pgdir != cur_pdir) continue;
      p->rss += 4096;    
      break;
    }
    release(&ptable.lock);

    rmap_add(V2P(newpg), cur_pdir);
  }
  swapslots[slotnum].is_free = 1; 
  for (int j=0; j<NPROC; j++) swapslots[slotnum].rmap_node.pgdirs[j] = 0;  
}

void clear_swap_slots(struct proc* p){
    pte_t* pgdir = p->pgdir;
    for (uint i = 0; i < NPDENTRIES; i++){
        if ((pgdir[i] & PTE_P) == 0) continue;
        pte_t *pgtable = (pte_t*)P2V(PTE_ADDR(pgdir[i]));
        for (uint j = 0; j < NPTENTRIES; j++){
            pte_t* pte = &pgtable[j];
            if (i==0 && j==0) continue;
            if (PTE_ADDR(*pte) == 0 || PGADDR(i, j, 0) >= p->sz) continue;

            if ((*pte & PTE_P) == 0){
                uint slot = *pte >> 12;
                rmap_rm_util(pgdir, &swapslots[slot].rmap_node);
                if (swapslots[slot].rmap_node.pgdirs[0] == 0){
                  swapslots[slot].is_free = 1;
                  for (int j=0; j<NPROC; j++) swapslots[slot].rmap_node.pgdirs[j] = 0;
                }
            }
        }
    }
}
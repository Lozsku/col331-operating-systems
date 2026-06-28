#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "cow.h"

#define NUMPAGES (PHYSTOP >> 12)

struct spinlock rmap_lock;
struct rmap_node rmap[NUMPAGES];

void rmap_add(uint addr, pde_t *pgdir){
  acquire(&rmap_lock);
  for (uint i=0; i<NPROC; i++){
    if (rmap[addr >> 12].pgdirs[i] == pgdir){
      break;
    }
    if (rmap[addr >> 12].pgdirs[i] == 0){
      rmap[addr >> 12].pgdirs[i] = pgdir;
      break;    
    }  
  }
  release(&rmap_lock);
}

void rmap_rm_util(pde_t *pgdir, struct rmap_node *node){
  uint i=0;
  while ((i<NPROC) && (node->pgdirs[i] != pgdir)) i++;
  if ((i<NPROC) && (node->pgdirs[i] == pgdir)){
    node->pgdirs[i] = 0;    
    i++;
    while (i<NPROC) {
      node->pgdirs[i-1] = node->pgdirs[i];
      i++;
    }
    node->pgdirs[i-1] = 0;
  }
}

void rmap_rm(uint addr, pde_t *pgdir){
  acquire(&rmap_lock);
  rmap_rm_util(pgdir, &rmap[addr >> 12]);
  release(&rmap_lock);
}

uint rmap_getcnt(uint addr){  
  acquire(&rmap_lock);
  uint pgdircnt = 0;
  for (uint j=0; j<NPROC; j++){
      if (rmap[addr >> 12].pgdirs[j] != 0) pgdircnt++;
    }
  release(&rmap_lock);
  return pgdircnt;
}

pde_t *rmap_get(uint addr, uint index){  
  pde_t *pgdir;
  acquire(&rmap_lock);
  pgdir = rmap[addr >> 12].pgdirs[index];
  release(&rmap_lock);
  return pgdir;
}

void rmap_clean(){
  acquire(&rmap_lock);
  for (uint i=0; i<NUMPAGES; i++){
    for (uint j=0; j<NPROC; j++){
      rmap[i].pgdirs[j] = 0;    
    }
  }
  release(&rmap_lock);
}

void rmap_clear_addr(uint addr){
  acquire(&rmap_lock);
  for (uint j=0; j<NPROC; j++){
    rmap[addr >> 12].pgdirs[j] = 0;    
  }
  release(&rmap_lock);
}

// walkpgdir from vm.c
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
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

void rmap_pgflt(uint va, pde_t *pgdir){
  va = PGROUNDDOWN(va);
  pde_t *pte = walkpgdir(pgdir, (char*) va, 0);   
  uint pa = PTE_ADDR(*pte);

  if (rmap_getcnt(pa) == 1){
      *pte |= PTE_W;
  } else {
      char* mem = kalloc();
      if(mem == 0){
          cprintf("out of memory\n");
          return;
      }
      memmove(mem, P2V(pa), PGSIZE);
      rmap_rm(pa, pgdir);
      rmap_add(V2P(mem), pgdir);
      *pte = V2P(mem) | PTE_W | PTE_P | PTE_U;
  }
  lcr3(V2P(pgdir));
}
# Lab 4 — Swap Space (base / skeleton)

This is my Lab 4 work for COL331 (Operating Systems), IIT Delhi.
Author: Somisetty Harsha Vardhan, entry no. 2020CS10390.

## The problem

As processes allocate more memory, xv6 can run out of physical pages and crash.
Lab 4 introduces a **swap space** on disk: unused memory pages are written to a
reserved set of disk blocks, freeing RAM for other processes, and faulted back in
on demand. The handout (`lab4.md`) describes a two-part lab — this is the first
(base) part, with demand paging to follow in 4b.

The design from the handout:

- **Disk:** a *swap-blocks* partition between the superblock and the log. It is
  split into *swap slots* of 8 consecutive disk blocks each (one page per slot).
  Each slot is a struct with `page_perm` and `is_free`. Writes to swap bypass the
  log layer (volatile data, no crash-consistency needed).
- **Page replacement:** track `rss` (resident pages) per process. Victim process
  = the one with the most resident pages (ties broken by lower pid). Victim page
  = one with `PTE_P` set and `PTE_A` clear; if none, clear `PTE_A` on ~10% of
  accessed pages and retry.
- **Swap out:** write the victim page into a free swap slot and update its PTE.
- **Swap in:** on `T_PGFLT`, read `cr2`, find the swap slot from the PTE,
  `kalloc()` a page, copy it back from disk, restore permissions, fix the PTE.

## What I did (this folder)

This is the **base/skeleton** stage. It has the bookkeeping the rest of the lab
builds on, but **no `pageswap.c`** yet (the actual swap-out/swap-in engine comes
later and lands in the project). What is in place here:

- `proc.h` — the `rss` field (resident memory size) on `struct proc`.
- `sysproc.c` — the two read-only helper system calls I must not change:
  - `getrss()` / `print_rss()` — report a process's resident page count.
  - `getNumFreePages()` — report the number of free physical pages.
- `memtest1.c`, `memtest2.c` — the provided memory-pressure tests.

The full copy-on-write + page-swapping implementation that completes this line of
work is in `../project-cow-page-swapping/` (it adds `pageswap.c` and `cow.c`).

### Key files

- `proc.h` — `rss`.
- `sysproc.c`, `syscall.c`, `syscall.h`, `user.h` — `getrss`, `getNumFreePages`.
- `memtest1.c`, `memtest2.c` — tests.

## Build and run

```sh
make clean
make qemu          # or make qemu-nox
```

At the xv6 shell run `memtest1` and `memtest2`. Without the swap engine these
tests fail under memory pressure (expected for the base stage) — they pass once
swapping is implemented (see the project).

## Notes

- Files I must not modify: `memlayout.h`, `mmu.h`, and the `getrss` /
  `getNumFreePages` system calls.
- `printpcs`, `cuth`, `spinp`, `toc.ftr` are xv6 build/runoff helper scripts, not
  lab code.

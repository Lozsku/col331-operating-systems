# Project — Copy-on-Write with Page Swapping in xv6

Final project for COL331/COL633 (Operating Systems), IIT Delhi.

**Team:**
- Somisetty Harsha Vardhan — 2020CS10390 (me)
- Medicharla Neeraj — 2021CS10087
- Kotikala Raghav — 2021CS50616

This was **team work** — the three of us built it together. The project report is
`../project_2021CS10087_2020CS10390_2021CS50616.pdf`; the assignment handout is
`project.md`.

## The problem

When xv6 `fork()`s, it copies the parent's entire address space into the child.
If neither process ever writes those pages, the copy is pure waste. The project
asked us to add **copy-on-write (COW)** — parent and child share the same
physical pages, marked read-only, and a page is only duplicated when someone
actually writes to it — and to combine COW with a disk **swap space** so shared
pages can be evicted under memory pressure and brought back on a page fault.

The handout breaks it into three stages:

1. **Share pages on fork.** In `copyuvm` (`vm.c`), duplicate the PTEs instead of
   the pages and mark the shared pages read-only.
2. **Handle writes.** A write to a read-only shared page raises `T_PGFLT`; the
   page-fault handler copies the page and remaps the faulting process's PTE.
3. **Optimize with `rmap` + add swapping.** A reverse map (`rmap`) tracks which
   processes reference each physical page. On a write fault, if only one process
   references the page we just flip it writable (no copy). With swapping enabled,
   `rmap` also lets us update every sharer's PTE when a shared page is swapped
   out, and restore them all when it is swapped back in.

## What we built

- **`cow.c` / `cow.h`** — the reverse map. `rmap[NUMPAGES]` records, per physical
  page, the set of page directories (`pgdirs[]`) referencing it. `rmap_add`,
  `rmap_rm`, `rmap_getcnt` (under `rmap_lock`) keep the reference info correct
  across fork/exit/kill and across write faults. This is what makes the
  single-reference fast path and correct multi-sharer PTE updates possible.
- **`pageswap.c`** — the swap engine. `swapslots[NSWAP]`, each
  `{ page_perm, is_free }`, manage the on-disk swap area; `swapinit` sets them up
  at boot, `swap_out()` picks and evicts a victim page into a free slot, and
  `swap_in(va, pgdir)` faults a page back in (kalloc, copy from disk, restore
  permissions and PTE). Swap writes bypass the log layer.
- **`vm.c`** — `copyuvm` shares PTEs read-only; integrates COW and swapping.
- **`trap.c`** — `T_PGFLT` handler that distinguishes a COW write fault from a
  swapped-out-page fault and dispatches to the copy path or `swap_in`.
- **Tests:** `testcow1.c`–`testcow4.c` and `memtest1.c`, `memtest2.c`.

The provided `get_rss` / `getNumFreePages` system calls are left unchanged, as
required; the grader overrides `memlayout.h` and `param.h`.

## Build and run

```sh
make clean
make qemu          # or make qemu-nox  for a terminal-only run
```

At the xv6 shell:

```
testcow1
testcow2
testcow3
testcow4
memtest1
memtest2
```

The `testcow*` programs check that fork shares pages and that writes correctly
trigger copies / writable-flips; `memtest*` push memory past physical RAM so the
swap path runs.

## Layout

- `base/` — the pre-COW base of this same xv6 tree (the starting point we were
  given, before COW and swapping). Kept for reference. `base/project.tar.xz` is a
  tarball of it.
- `project_2021CS10087_2020CS10390_2021CS50616.tar.gz` — the packaged final
  submission of this folder.

## Notes

This project continues the swap-space line of work started in
`../lab4-swap-base/` (which has the `rss` / `getNumFreePages` bookkeeping but no
swap engine) and adds the full COW + page-swapping implementation on top.

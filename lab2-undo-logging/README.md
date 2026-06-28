# Lab 2 — Undo Logging in the File System

This is my Lab 2 submission for COL331 (Operating Systems), IIT Delhi.
Author: Somisetty Harsha Vardhan, entry no. 2020CS10390.

## The problem

xv6 ships with a **redo** write-ahead log (covered in `p12-log.md`): blocks are
written to the log first and only copied to their home location at commit. This
lab asked me to replace it with an **undo** log instead.

Undo logging records the **old** value of every block before it is overwritten in
place. On a crash, recovery just rewrites those old values back, undoing any
half-finished transaction. The trade-offs versus redo logging are discussed in
`lab2.md` (the course handout).

Two extra requirements made it interesting:

1. **No extra disk reads.** Naively, logging the old value means reading the
   block back from disk. To avoid that, the skeleton added `bread_wr()` in
   `bio.c`, which `fs.c` now calls wherever a block is about to be modified. My
   `bread_wr` had to cache the block's old contents in the buffer so the log
   layer can use them later without touching the disk.
2. **Eager logging.** Redo logs write to the log lazily (only at commit). My undo
   log had to write the old value to the on-disk log **as soon as** a block is
   changed.

I was not allowed to touch `commit()` in `log.c`, `main()` in `main.c`, or the
`bread_wr` call sites in `fs.c`.

## What I did

All my changes live in `log.c` and `bio.c`:

- **`bio.c` / `bread_wr`** — returns the buffer for a block that is about to be
  modified and snapshots its current (old) contents, so writing the undo log
  needs no additional read.
- **`log.c`** — reworked the logging machinery to undo semantics: log header
  tracks the block numbers whose old values are saved; `install_trans` and
  `recover_from_log` rewrite the saved old values back on recovery; writes to the
  on-disk log happen eagerly when a block is modified rather than at commit.

The panic messages I added are tagged `[UNDOLOG]` so it is easy to see the undo
path firing during testing.

### Key files

- `log.c` — undo log header, eager log writes, recovery.
- `bio.c` — `bread_wr` and old-value caching in the buffer cache.
- `fs.c` — uses `bread_wr` at modification sites (call sites unchanged).

## Build and run

```sh
make clean
make qemu          # or make qemu-nox
```

At the xv6 shell, exercise the file system (create/append/delete files, run
`usertests`) to drive the undo log. To check crash consistency, the autograder
kills QEMU mid-transaction and reboots; recovery should leave the file system in
a consistent (pre-transaction) state.

## Notes

- `lab2.tar.gz` is the packaged submission of this folder.

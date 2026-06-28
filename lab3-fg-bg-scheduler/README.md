# Lab 3 — Foreground/Background Scheduler in xv6

This is my Lab 3 submission for COL331 (Operating Systems), IIT Delhi.
Author: Somisetty Harsha Vardhan, entry no. 2020CS10390.

## The problem

xv6's default scheduler is plain round-robin: every runnable process gets an
equal turn, with no notion of priority. The lab asked me to add a simple
two-class scheduler:

- **Foreground** processes (`policy = 0`) — interactive, time-sensitive; should
  get **90%** of CPU time.
- **Background** processes (`policy = 1`) — long, non-interactive; should get the
  remaining **10%**.

Within each class, scheduling stays round-robin. No process may starve: if there
are no background processes the CPU goes back to foreground ones, and vice versa.

The handout is in `lab3.md`.

## What I did

**System calls** (in `sysproc.c`, registered in `syscall.h` / `user.h`):

- `set_sched_policy()` — sets the calling process's `policy` field. Returns `0`
  on success, `-22` (`-EINVAL`) for an invalid policy.
- `get_sched_policy()` — returns the calling process's current policy.

`proc.h` carries the new `int policy` field per process.

**Scheduler** (in `proc.c`, the `scheduler()` function): I split each window of
ticks into a 90/10 budget — roughly `ticks * 9 / 10` for foreground and
`ticks / 10` for background (see `first_pro_sec` / `endba_proc_sec` in the code).
Inside each class I keep the original round-robin walk over the process table. If
one class is empty I fall through to the other so the CPU never idles while work
exists.

### Key files

- `proc.c` — the 90/10 scheduler and the `policy` plumbing.
- `proc.h` — the `policy` field.
- `sysproc.c`, `syscall.c`, `syscall.h`, `user.h` — the two new system calls.
- `init.c` — the test driver: `pinit` is called twice with different policies,
  and an infinite task prints "Task done by process with sched policy N".

## Build and run

```sh
make clean
make qemu          # or make qemu-nox
```

Expected behaviour: the line `Task done by process with sched policy 0`
(foreground) appears roughly **9×** as often as `... sched policy 1`
(background), matching the 90/10 split.

## Notes

- `col331-lab3.tar.gz` and `lab3_2020CS10390.tar.gz` are packaged versions of
  this submission.

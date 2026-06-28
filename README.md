# COL331 — Operating Systems (my course journal)

This folder collects everything I did in **COL331 (Operating Systems)** at
IIT Delhi: four xv6 kernel labs, a team project, and my exam. I'm Somisetty
Harsha Vardhan (entry no. 2020CS10390), CSE. The course was taught by
Prof. Abhilash Jindal.

I wrote this README as a running account of what the course was about, what I
built in each lab and the project, and what I actually learned along the way.

## What the course was about

COL331 builds an operating system the slow, honest way: you take
[xv6](https://pdos.csail.mit.edu/6.828/xv6/) — a small teaching re-implementation
of Unix V6 for x86 — and keep modifying it until you've touched almost every part
of a kernel. The lectures and the "xv6 step by step" notes (`p1-booting.md`,
`p2-print.md`, … shipped inside each lab) walk through booting, interrupts, the
file system, scheduling, and virtual memory. Each lab then drops you into that
code and asks you to add one real piece yourself.

By the end I'd worked on the kernel from the boot sector all the way up to
copy-on-write fork and disk swapping. The labs got steadily harder and moved up
the stack: a device driver, then the file system, then the scheduler, then
virtual memory.

## The labs and project

### `lab1-mouse-driver/` — PS/2 mouse driver
My first real kernel code. xv6 could already read a keyboard; I added support for
a PS/2 **mouse**. That meant talking to the PS/2 controller through its data and
status ports (`0x60` / `0x64`), getting the command/acknowledge handshake right,
enabling the mouse interrupt by editing the Compaq status byte, and wiring
`IRQ12` through the trap path so movement packets get decoded. This is where I
got comfortable with port I/O, interrupt enabling via the IOAPIC, and how an
interrupt actually travels into `trap()`.

### `lab2-undo-logging/` — undo logging in the file system
xv6 uses a redo write-ahead log for crash consistency. I replaced it with an
**undo** log: save each block's old value before overwriting it in place, and on
a crash rewrite those old values to roll the transaction back. The catch was
doing it without extra disk reads (I cached old block contents in the buffer
cache via `bread_wr`) and writing the log **eagerly** as blocks change rather
than lazily at commit. This forced me to really understand the buffer cache, the
log layer, and what "atomic with respect to crashes" means in practice.

### `lab3-fg-bg-scheduler/` — foreground/background scheduler
I changed xv6's plain round-robin scheduler into a two-class one. Processes can
declare themselves **foreground** (interactive, 90% of CPU) or **background**
(batch, 10%) through two new system calls (`set_sched_policy` /
`get_sched_policy`), and the scheduler hands out time on that 90/10 budget while
staying round-robin inside each class and never starving either side. Good
hands-on exposure to adding system calls end-to-end and to how the scheduler
loop and `struct proc` fit together.

### `lab4-swap-base/` — swap-space base
The first half of the swap-space lab. Here I set up the bookkeeping that paging
needs — per-process resident set size (`rss`) and the read-only `getrss` /
`getNumFreePages` system calls — and the memory-pressure tests. The actual
swap-out/swap-in engine (`pageswap.c`) isn't in this stage; it lands in the
project. This is the skeleton the virtual-memory work grows out of.

### `project-cow-page-swapping/` — Copy-on-Write + swapping (team)
The capstone, done as a **team**: me (2020CS10390), Medicharla Neeraj
(2021CS10087), and Kotikala Raghav (2021CS50616). We made `fork()` use
**copy-on-write** — parent and child share read-only pages and only copy on a
write fault — and combined it with a disk **swap space** so shared pages can be
evicted under memory pressure and faulted back in. The interesting part was the
reverse map (`rmap` in `cow.c`): tracking which processes reference each physical
page so we could take the no-copy fast path when only one referenced it, and
correctly update *every* sharer's page table entry when a shared page was swapped
out and later swapped in. The swap engine itself lives in `pageswap.c`. This tied
together everything from lab 4 with page faults, page tables, and reference
counting.

## Other things in this folder

- `exam/` — my graded COL331 exam (`submission_252526008.pdf`).
- `project_2021CS10087_2020CS10390_2021CS50616.pdf` — our project report.

## Folder structure

```
col331-operating-systems/
├── lab1-mouse-driver/            # PS/2 mouse driver, IRQ12
├── lab2-undo-logging/            # undo log in the FS
├── lab3-fg-bg-scheduler/         # 90/10 fg/bg scheduler
├── lab4-swap-base/               # swap-space base / rss bookkeeping
├── project-cow-page-swapping/    # COW + swapping (team), base/ = pre-COW tree
├── exam/                         # my graded exam
└── project_..._.pdf              # project report (team)
```

## How to build and run any lab

Every lab and the project is a self-contained xv6 tree built with `make` and run
under QEMU:

```sh
cd <lab-or-project-folder>
make clean
make qemu          # graphical QEMU window
# or
make qemu-nox      # terminal-only, no window
```

Each folder has its own README with the specific build/run/test details and the
expected output.

## What I learned / skills

- **Kernel C and xv6 internals** — reading and modifying a real (if small)
  kernel: the boot chain (`bootasm.S` → `bootmain.c` → `entry.S` → `main.c`),
  `struct proc`, page tables (`vm.c`, `walkpgdir`, `copyuvm`), and the physical
  page allocator (`kalloc.c`).
- **Interrupts and device I/O** — port I/O to a PS/2 controller, the
  command/acknowledge handshake, enabling IRQs through the IOAPIC, and the trap
  path (`trapasm.S` → `trap()`).
- **File systems and crash consistency** — the buffer cache, write-ahead logging,
  and the difference between redo and undo logging in practice.
- **Scheduling** — adding system calls end-to-end and reshaping the scheduler
  loop to enforce a CPU budget without starvation.
- **Virtual memory** — demand paging, swap space on disk, page-fault handling,
  copy-on-write, and reference counting with a reverse map (`rmap`).
- **Debugging kernels** — using QEMU + GDB, reading panics, and reasoning about
  concurrency and locking (e.g. the `rmap_lock` around the reverse map).
- **Working in a team** on a sizeable systems project and splitting up
  COW vs. swapping while keeping the page tables consistent across both.

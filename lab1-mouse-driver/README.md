# Lab 1 — PS/2 Mouse Driver in xv6

This is my Lab 1 submission for COL331 (Operating Systems), IIT Delhi.
Author: Somisetty Harsha Vardhan, entry no. 2020CS10390.

## The problem

xv6 already knows how to read a PS/2 **keyboard**. The lab asked me to add
primitive support for a PS/2 **mouse** to the same kernel. A PS/2 mouse talks to
the CPU through the PS/2 controller (data port `0x60`, command/status port
`0x64`) and raises `IRQ12` whenever its state changes. The skeleton in `mouse.c`
gave me empty function stubs and constants in `mouse.h`; my job was to fill them
in and wire the interrupt into the trap path.

The course handout for this lab is in `lab1.md`. The `p1`–`p5` markdown notes
(`p1-booting.md` … `p5-input.md`) are the "xv6 step by step" reading that builds
up to keyboard/mouse input.

## What I did

I implemented the controller-handshake helpers and the init/interrupt path in
`mouse.c`:

- `mousewait_send()` — spins until bit 1 (value 2) of port `0x64` is clear, so it
  is safe to write a byte to the controller.
- `mousewait_recv()` — spins until bit 0 (value 1) of port `0x64` is set, so a
  byte is ready to read from `0x60`.
- `mousecmd(cmd)` — sends `0xD4` to `0x64` (address the mouse), then `cmd` to
  `0x60`, then waits for and reads the `0xFA` acknowledgement.
- `mouseinit()` — enables the mouse (`0xA8`), reads/edits the Compaq status byte
  (`0x20` / `0x60`) to turn on the mouse interrupt bit, sets defaults (`0xF6`),
  enables packet streaming (`0xF4`), and finally calls
  `ioapicenable(IRQ_MOUSE, 0)` so IRQ12 is delivered to CPU 0.
- `mouseintr()` — reads the 3-byte movement packet (flags, dx, dy) and prints the
  decoded mouse state.

I also hooked `mouseinit()` into kernel startup and added the `IRQ_MOUSE` case in
`trap.c` (it calls `mouseintr()`).

### Key files

- `mouse.c`, `mouse.h` — the whole driver and its constants.
- `trap.c` — IRQ12 handler dispatch.
- `main.c` — calls `mouseinit()` at boot.

## Build and run

```sh
make clean
make qemu          # or: make qemu-nox  for a terminal-only run
```

In QEMU, move the mouse over the window. Each movement raises IRQ12 and the
kernel prints the decoded packet (button flags and dx/dy) to the console.

## Notes

- `check_scripts_lab1/` is the autograder bundle I used to test this lab. It
  contains my own submission tarballs (`lab1_2020CS10390*.tar.gz`) and the
  `marks.csv` only lists `2020CS10390` — it is my own grading run, kept here
  with the lab.
- `lab1_2020CS10390.tar.gz` is the packaged submission of this folder.
- The OSDev "Mouse Input" wiki page was my main reference for the handshake
  sequence.

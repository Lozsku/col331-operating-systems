
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc 10 34 10 00       	mov    $0x103410,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 90 06 10 00       	mov    $0x100690,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax
  100018:	66 90                	xchg   %ax,%ax
  10001a:	66 90                	xchg   %ax,%ax
  10001c:	66 90                	xchg   %ax,%ax
  10001e:	66 90                	xchg   %ax,%ax

00100020 <printint>:
static void consputc(int);
static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100020:	55                   	push   %ebp
  100021:	89 e5                	mov    %esp,%ebp
  100023:	57                   	push   %edi
  100024:	56                   	push   %esi
  100025:	53                   	push   %ebx
  100026:	83 ec 2c             	sub    $0x2c,%esp
  100029:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10002c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  10002f:	85 c9                	test   %ecx,%ecx
  100031:	74 04                	je     100037 <printint+0x17>
  100033:	85 c0                	test   %eax,%eax
  100035:	78 79                	js     1000b0 <printint+0x90>
    x = -xx;
  else
    x = xx;
  100037:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  10003e:	89 c1                	mov    %eax,%ecx

  i = 0;
  100040:	31 db                	xor    %ebx,%ebx
  100042:	8d 7d d7             	lea    -0x29(%ebp),%edi
  100045:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
  100048:	89 c8                	mov    %ecx,%eax
  10004a:	31 d2                	xor    %edx,%edx
  10004c:	89 ce                	mov    %ecx,%esi
  10004e:	f7 75 d4             	divl   -0x2c(%ebp)
  100051:	0f be 92 44 1b 10 00 	movsbl 0x101b44(%edx),%edx
  100058:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10005b:	89 d8                	mov    %ebx,%eax
  10005d:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
  100060:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    buf[i++] = digits[x % base];
  100063:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
  100066:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
  100069:	73 dd                	jae    100048 <printint+0x28>
  10006b:	89 c6                	mov    %eax,%esi

  if(sign)
  10006d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  100070:	85 c0                	test   %eax,%eax
  100072:	74 0c                	je     100080 <printint+0x60>
    buf[i++] = '-';
  100074:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
  100079:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
  10007b:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
  100080:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  100084:	eb 10                	jmp    100096 <printint+0x76>
  100086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10008d:	8d 76 00             	lea    0x0(%esi),%esi
  100090:	0f be 13             	movsbl (%ebx),%edx
  100093:	83 eb 01             	sub    $0x1,%ebx
consputc(int c)
{
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  100096:	83 ec 0c             	sub    $0xc,%esp
  100099:	52                   	push   %edx
  10009a:	e8 91 09 00 00       	call   100a30 <uartputc>
  while(--i >= 0)
  10009f:	83 c4 10             	add    $0x10,%esp
  1000a2:	39 fb                	cmp    %edi,%ebx
  1000a4:	75 ea                	jne    100090 <printint+0x70>
}
  1000a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1000a9:	5b                   	pop    %ebx
  1000aa:	5e                   	pop    %esi
  1000ab:	5f                   	pop    %edi
  1000ac:	5d                   	pop    %ebp
  1000ad:	c3                   	ret    
  1000ae:	66 90                	xchg   %ax,%ax
    x = -xx;
  1000b0:	f7 d8                	neg    %eax
  1000b2:	89 c1                	mov    %eax,%ecx
  1000b4:	eb 8a                	jmp    100040 <printint+0x20>
  1000b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1000bd:	8d 76 00             	lea    0x0(%esi),%esi

001000c0 <consputc.part.0>:
consputc(int c)
  1000c0:	55                   	push   %ebp
  1000c1:	89 e5                	mov    %esp,%ebp
  1000c3:	83 ec 14             	sub    $0x14,%esp
    uartputc('\b'); uartputc(' '); uartputc('\b');
  1000c6:	6a 08                	push   $0x8
  1000c8:	e8 63 09 00 00       	call   100a30 <uartputc>
  1000cd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1000d4:	e8 57 09 00 00       	call   100a30 <uartputc>
  1000d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1000e0:	e8 4b 09 00 00       	call   100a30 <uartputc>
}
  1000e5:	83 c4 10             	add    $0x10,%esp
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    
  1000ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001000f0 <cprintf>:
{
  1000f0:	f3 0f 1e fb          	endbr32 
  1000f4:	55                   	push   %ebp
  1000f5:	89 e5                	mov    %esp,%ebp
  1000f7:	57                   	push   %edi
  1000f8:	56                   	push   %esi
  1000f9:	53                   	push   %ebx
  1000fa:	83 ec 1c             	sub    $0x1c,%esp
  if (fmt == 0)
  1000fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100103:	85 c0                	test   %eax,%eax
  100105:	0f 84 88 00 00 00    	je     100193 <cprintf+0xa3>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10010b:	0f b6 10             	movzbl (%eax),%edx
  10010e:	85 d2                	test   %edx,%edx
  100110:	0f 84 7d 00 00 00    	je     100193 <cprintf+0xa3>
  argp = (uint*)(void*)(&fmt + 1);
  100116:	8d 45 0c             	lea    0xc(%ebp),%eax
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100119:	31 db                	xor    %ebx,%ebx
  10011b:	eb 4d                	jmp    10016a <cprintf+0x7a>
  10011d:	8d 76 00             	lea    0x0(%esi),%esi
    c = fmt[++i] & 0xff;
  100120:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
  100123:	85 d2                	test   %edx,%edx
  100125:	74 6c                	je     100193 <cprintf+0xa3>
    switch(c){
  100127:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10012a:	83 c3 02             	add    $0x2,%ebx
  10012d:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  100130:	83 fa 70             	cmp    $0x70,%edx
  100133:	0f 84 b4 00 00 00    	je     1001ed <cprintf+0xfd>
  100139:	7f 65                	jg     1001a0 <cprintf+0xb0>
  10013b:	83 fa 25             	cmp    $0x25,%edx
  10013e:	0f 84 ec 00 00 00    	je     100230 <cprintf+0x140>
  100144:	83 fa 64             	cmp    $0x64,%edx
  100147:	0f 85 b8 00 00 00    	jne    100205 <cprintf+0x115>
      printint(*argp++, 10, 1);
  10014d:	8d 78 04             	lea    0x4(%eax),%edi
  100150:	8b 00                	mov    (%eax),%eax
  100152:	b9 01 00 00 00       	mov    $0x1,%ecx
  100157:	ba 0a 00 00 00       	mov    $0xa,%edx
  10015c:	e8 bf fe ff ff       	call   100020 <printint>
  100161:	89 f8                	mov    %edi,%eax
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100163:	0f b6 16             	movzbl (%esi),%edx
  100166:	85 d2                	test   %edx,%edx
  100168:	74 29                	je     100193 <cprintf+0xa3>
    if(c != '%'){
  10016a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10016d:	8d 7b 01             	lea    0x1(%ebx),%edi
  100170:	8d 34 39             	lea    (%ecx,%edi,1),%esi
  100173:	83 fa 25             	cmp    $0x25,%edx
  100176:	74 a8                	je     100120 <cprintf+0x30>
    uartputc(c);
  100178:	83 ec 0c             	sub    $0xc,%esp
  10017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      continue;
  10017e:	89 fb                	mov    %edi,%ebx
    uartputc(c);
  100180:	52                   	push   %edx
  100181:	e8 aa 08 00 00       	call   100a30 <uartputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100186:	0f b6 16             	movzbl (%esi),%edx
      continue;
  100189:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10018c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10018f:	85 d2                	test   %edx,%edx
  100191:	75 d7                	jne    10016a <cprintf+0x7a>
}
  100193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100196:	5b                   	pop    %ebx
  100197:	5e                   	pop    %esi
  100198:	5f                   	pop    %edi
  100199:	5d                   	pop    %ebp
  10019a:	c3                   	ret    
  10019b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10019f:	90                   	nop
    switch(c){
  1001a0:	83 fa 73             	cmp    $0x73,%edx
  1001a3:	75 43                	jne    1001e8 <cprintf+0xf8>
      if((s = (char*)*argp++) == 0)
  1001a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1001a8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  1001ab:	8b 08                	mov    (%eax),%ecx
  1001ad:	85 c9                	test   %ecx,%ecx
  1001af:	0f 84 9b 00 00 00    	je     100250 <cprintf+0x160>
      for(; *s; s++)
  1001b5:	0f be 11             	movsbl (%ecx),%edx
      if((s = (char*)*argp++) == 0)
  1001b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1001bb:	89 cf                	mov    %ecx,%edi
      for(; *s; s++)
  1001bd:	84 d2                	test   %dl,%dl
  1001bf:	74 a2                	je     100163 <cprintf+0x73>
  1001c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
  1001c8:	83 ec 0c             	sub    $0xc,%esp
      for(; *s; s++)
  1001cb:	83 c7 01             	add    $0x1,%edi
    uartputc(c);
  1001ce:	52                   	push   %edx
  1001cf:	e8 5c 08 00 00       	call   100a30 <uartputc>
      for(; *s; s++)
  1001d4:	0f be 17             	movsbl (%edi),%edx
  1001d7:	83 c4 10             	add    $0x10,%esp
  1001da:	84 d2                	test   %dl,%dl
  1001dc:	75 ea                	jne    1001c8 <cprintf+0xd8>
}
  1001de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1001e1:	eb 80                	jmp    100163 <cprintf+0x73>
  1001e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1001e7:	90                   	nop
    switch(c){
  1001e8:	83 fa 78             	cmp    $0x78,%edx
  1001eb:	75 18                	jne    100205 <cprintf+0x115>
      printint(*argp++, 16, 0);
  1001ed:	8d 78 04             	lea    0x4(%eax),%edi
  1001f0:	8b 00                	mov    (%eax),%eax
  1001f2:	31 c9                	xor    %ecx,%ecx
  1001f4:	ba 10 00 00 00       	mov    $0x10,%edx
  1001f9:	e8 22 fe ff ff       	call   100020 <printint>
  1001fe:	89 f8                	mov    %edi,%eax
      break;
  100200:	e9 5e ff ff ff       	jmp    100163 <cprintf+0x73>
    uartputc(c);
  100205:	83 ec 0c             	sub    $0xc,%esp
  100208:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10020b:	6a 25                	push   $0x25
  10020d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  100210:	e8 1b 08 00 00       	call   100a30 <uartputc>
  100215:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100218:	89 14 24             	mov    %edx,(%esp)
  10021b:	e8 10 08 00 00       	call   100a30 <uartputc>
}
  100220:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100223:	83 c4 10             	add    $0x10,%esp
  100226:	e9 38 ff ff ff       	jmp    100163 <cprintf+0x73>
  10022b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10022f:	90                   	nop
    uartputc(c);
  100230:	83 ec 0c             	sub    $0xc,%esp
  100233:	89 45 e0             	mov    %eax,-0x20(%ebp)
  100236:	6a 25                	push   $0x25
  100238:	e8 f3 07 00 00       	call   100a30 <uartputc>
}
  10023d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100240:	83 c4 10             	add    $0x10,%esp
  100243:	e9 1b ff ff ff       	jmp    100163 <cprintf+0x73>
  100248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10024f:	90                   	nop
        s = "(null)";
  100250:	bf 14 1b 10 00       	mov    $0x101b14,%edi
      for(; *s; s++)
  100255:	ba 28 00 00 00       	mov    $0x28,%edx
  10025a:	e9 69 ff ff ff       	jmp    1001c8 <cprintf+0xd8>
  10025f:	90                   	nop

00100260 <halt>:
{
  100260:	f3 0f 1e fb          	endbr32 
  100264:	55                   	push   %ebp
  100265:	89 e5                	mov    %esp,%ebp
  100267:	83 ec 10             	sub    $0x10,%esp
  cprintf("Bye COL%d!\n\0", 331);
  10026a:	68 4b 01 00 00       	push   $0x14b
  10026f:	68 34 1b 10 00       	push   $0x101b34
  100274:	e8 77 fe ff ff       	call   1000f0 <cprintf>
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100279:	b8 00 20 00 00       	mov    $0x2000,%eax
  10027e:	ba 02 06 00 00       	mov    $0x602,%edx
  100283:	66 ef                	out    %ax,(%dx)
  100285:	ba 02 b0 ff ff       	mov    $0xffffb002,%edx
  10028a:	66 ef                	out    %ax,(%dx)
}
  10028c:	83 c4 10             	add    $0x10,%esp
  for(;;);
  10028f:	eb fe                	jmp    10028f <halt+0x2f>
  100291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10029f:	90                   	nop

001002a0 <panic>:
{
  1002a0:	f3 0f 1e fb          	endbr32 
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	56                   	push   %esi
  1002a8:	53                   	push   %ebx
  1002a9:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
  1002ac:	fa                   	cli    
  cprintf("lapicid %d: panic: ", lapicid());
  1002ad:	e8 8e 03 00 00       	call   100640 <lapicid>
  1002b2:	83 ec 08             	sub    $0x8,%esp
  getcallerpcs(&s, pcs);
  1002b5:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  1002b8:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
  1002bb:	50                   	push   %eax
  1002bc:	68 1b 1b 10 00       	push   $0x101b1b
  1002c1:	e8 2a fe ff ff       	call   1000f0 <cprintf>
  cprintf(s);
  1002c6:	58                   	pop    %eax
  1002c7:	ff 75 08             	push   0x8(%ebp)
  1002ca:	e8 21 fe ff ff       	call   1000f0 <cprintf>
  cprintf("\n");
  1002cf:	c7 04 24 d1 1b 10 00 	movl   $0x101bd1,(%esp)
  1002d6:	e8 15 fe ff ff       	call   1000f0 <cprintf>
  getcallerpcs(&s, pcs);
  1002db:	8d 45 08             	lea    0x8(%ebp),%eax
  1002de:	5a                   	pop    %edx
  1002df:	59                   	pop    %ecx
  1002e0:	53                   	push   %ebx
  1002e1:	50                   	push   %eax
  1002e2:	e8 49 0a 00 00       	call   100d30 <getcallerpcs>
  for(i=0; i<10; i++)
  1002e7:	83 c4 10             	add    $0x10,%esp
  1002ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" %p", pcs[i]);
  1002f0:	83 ec 08             	sub    $0x8,%esp
  1002f3:	ff 33                	push   (%ebx)
  1002f5:	83 c3 04             	add    $0x4,%ebx
  1002f8:	68 2f 1b 10 00       	push   $0x101b2f
  1002fd:	e8 ee fd ff ff       	call   1000f0 <cprintf>
  for(i=0; i<10; i++)
  100302:	83 c4 10             	add    $0x10,%esp
  100305:	39 f3                	cmp    %esi,%ebx
  100307:	75 e7                	jne    1002f0 <panic+0x50>
  halt();
  100309:	e8 52 ff ff ff       	call   100260 <halt>
  10030e:	66 90                	xchg   %ax,%ax

00100310 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100310:	f3 0f 1e fb          	endbr32 
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	53                   	push   %ebx
  100318:	83 ec 14             	sub    $0x14,%esp
  10031b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  while((c = getc()) >= 0){
  10031e:	66 90                	xchg   %ax,%ax
  100320:	ff d3                	call   *%ebx
  100322:	85 c0                	test   %eax,%eax
  100324:	78 77                	js     10039d <consoleintr+0x8d>
    switch(c){
  100326:	83 f8 15             	cmp    $0x15,%eax
  100329:	0f 84 98 00 00 00    	je     1003c7 <consoleintr+0xb7>
  10032f:	83 f8 7f             	cmp    $0x7f,%eax
  100332:	0f 84 a8 00 00 00    	je     1003e0 <consoleintr+0xd0>
  100338:	83 f8 08             	cmp    $0x8,%eax
  10033b:	0f 84 9f 00 00 00    	je     1003e0 <consoleintr+0xd0>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100341:	85 c0                	test   %eax,%eax
  100343:	74 db                	je     100320 <consoleintr+0x10>
  100345:	8b 15 a8 34 10 00    	mov    0x1034a8,%edx
  10034b:	89 d1                	mov    %edx,%ecx
  10034d:	2b 0d a0 34 10 00    	sub    0x1034a0,%ecx
  100353:	83 f9 7f             	cmp    $0x7f,%ecx
  100356:	77 c8                	ja     100320 <consoleintr+0x10>
        c = (c == '\r') ? '\n' : c;
  100358:	8d 4a 01             	lea    0x1(%edx),%ecx
  10035b:	83 e2 7f             	and    $0x7f,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
  10035e:	89 0d a8 34 10 00    	mov    %ecx,0x1034a8
        c = (c == '\r') ? '\n' : c;
  100364:	83 f8 0d             	cmp    $0xd,%eax
  100367:	0f 84 96 00 00 00    	je     100403 <consoleintr+0xf3>
        input.buf[input.e++ % INPUT_BUF] = c;
  10036d:	88 82 20 34 10 00    	mov    %al,0x103420(%edx)
  if(c == BACKSPACE){
  100373:	3d 00 01 00 00       	cmp    $0x100,%eax
  100378:	0f 85 a8 00 00 00    	jne    100426 <consoleintr+0x116>
  10037e:	e8 3d fd ff ff       	call   1000c0 <consputc.part.0>
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100383:	a1 a0 34 10 00       	mov    0x1034a0,%eax
  100388:	83 e8 80             	sub    $0xffffff80,%eax
  10038b:	39 05 a8 34 10 00    	cmp    %eax,0x1034a8
  100391:	0f 84 85 00 00 00    	je     10041c <consoleintr+0x10c>
  while((c = getc()) >= 0){
  100397:	ff d3                	call   *%ebx
  100399:	85 c0                	test   %eax,%eax
  10039b:	79 89                	jns    100326 <consoleintr+0x16>
        }
      }
      break;
    }
  }
  10039d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1003a0:	c9                   	leave  
  1003a1:	c3                   	ret    
  1003a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003a8:	83 e8 01             	sub    $0x1,%eax
  1003ab:	89 c2                	mov    %eax,%edx
  1003ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
  1003b0:	80 ba 20 34 10 00 0a 	cmpb   $0xa,0x103420(%edx)
  1003b7:	0f 84 63 ff ff ff    	je     100320 <consoleintr+0x10>
        input.e--;
  1003bd:	a3 a8 34 10 00       	mov    %eax,0x1034a8
  if(c == BACKSPACE){
  1003c2:	e8 f9 fc ff ff       	call   1000c0 <consputc.part.0>
      while(input.e != input.w &&
  1003c7:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  1003cc:	3b 05 a4 34 10 00    	cmp    0x1034a4,%eax
  1003d2:	75 d4                	jne    1003a8 <consoleintr+0x98>
  1003d4:	e9 47 ff ff ff       	jmp    100320 <consoleintr+0x10>
  1003d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
  1003e0:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  1003e5:	3b 05 a4 34 10 00    	cmp    0x1034a4,%eax
  1003eb:	0f 84 2f ff ff ff    	je     100320 <consoleintr+0x10>
        input.e--;
  1003f1:	83 e8 01             	sub    $0x1,%eax
  1003f4:	a3 a8 34 10 00       	mov    %eax,0x1034a8
  if(c == BACKSPACE){
  1003f9:	e8 c2 fc ff ff       	call   1000c0 <consputc.part.0>
  1003fe:	e9 1d ff ff ff       	jmp    100320 <consoleintr+0x10>
    uartputc(c);
  100403:	83 ec 0c             	sub    $0xc,%esp
        input.buf[input.e++ % INPUT_BUF] = c;
  100406:	c6 82 20 34 10 00 0a 	movb   $0xa,0x103420(%edx)
    uartputc(c);
  10040d:	6a 0a                	push   $0xa
  10040f:	e8 1c 06 00 00       	call   100a30 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100414:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  100419:	83 c4 10             	add    $0x10,%esp
          input.w = input.e;
  10041c:	a3 a4 34 10 00       	mov    %eax,0x1034a4
  100421:	e9 fa fe ff ff       	jmp    100320 <consoleintr+0x10>
    uartputc(c);
  100426:	83 ec 0c             	sub    $0xc,%esp
  100429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10042c:	50                   	push   %eax
  10042d:	e8 fe 05 00 00       	call   100a30 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	83 c4 10             	add    $0x10,%esp
  100438:	83 f8 0a             	cmp    $0xa,%eax
  10043b:	74 09                	je     100446 <consoleintr+0x136>
  10043d:	83 f8 04             	cmp    $0x4,%eax
  100440:	0f 85 3d ff ff ff    	jne    100383 <consoleintr+0x73>
  100446:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  10044b:	eb cf                	jmp    10041c <consoleintr+0x10c>
  10044d:	66 90                	xchg   %ax,%ax
  10044f:	90                   	nop

00100450 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  100450:	f3 0f 1e fb          	endbr32 
  100454:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  100455:	c7 05 ac 34 10 00 00 	movl   $0xfec00000,0x1034ac
  10045c:	00 c0 fe 
{
  10045f:	89 e5                	mov    %esp,%ebp
  100461:	56                   	push   %esi
  100462:	53                   	push   %ebx
  ioapic->reg = reg;
  100463:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10046a:	00 00 00 
  return ioapic->data;
  10046d:	8b 15 ac 34 10 00    	mov    0x1034ac,%edx
  100473:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
  100476:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
  10047c:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  100482:	0f b6 15 b4 34 10 00 	movzbl 0x1034b4,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  100489:	c1 ee 10             	shr    $0x10,%esi
  10048c:	89 f0                	mov    %esi,%eax
  10048e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
  100491:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
  100494:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
  100497:	39 c2                	cmp    %eax,%edx
  100499:	74 16                	je     1004b1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  10049b:	83 ec 0c             	sub    $0xc,%esp
  10049e:	68 58 1b 10 00       	push   $0x101b58
  1004a3:	e8 48 fc ff ff       	call   1000f0 <cprintf>
  1004a8:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004ae:	83 c4 10             	add    $0x10,%esp
  1004b1:	83 c6 21             	add    $0x21,%esi
{
  1004b4:	ba 10 00 00 00       	mov    $0x10,%edx
  1004b9:	b8 20 00 00 00       	mov    $0x20,%eax
  1004be:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
  1004c0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  1004c2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
  1004c4:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004ca:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  1004cd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
  1004d3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
  1004d6:	8d 5a 01             	lea    0x1(%edx),%ebx
  1004d9:	83 c2 02             	add    $0x2,%edx
  1004dc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
  1004de:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004e4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
  1004eb:	39 f0                	cmp    %esi,%eax
  1004ed:	75 d1                	jne    1004c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  1004ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1004f2:	5b                   	pop    %ebx
  1004f3:	5e                   	pop    %esi
  1004f4:	5d                   	pop    %ebp
  1004f5:	c3                   	ret    
  1004f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004fd:	8d 76 00             	lea    0x0(%esi),%esi

00100500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  100500:	f3 0f 1e fb          	endbr32 
  100504:	55                   	push   %ebp
  ioapic->reg = reg;
  100505:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
{
  10050b:	89 e5                	mov    %esp,%ebp
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  100510:	8d 50 20             	lea    0x20(%eax),%edx
  100513:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
  100517:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  100519:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10051f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
  100522:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  100525:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
  100528:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  10052a:	a1 ac 34 10 00       	mov    0x1034ac,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10052f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
  100532:	89 50 10             	mov    %edx,0x10(%eax)
}
  100535:	5d                   	pop    %ebp
  100536:	c3                   	ret    
  100537:	66 90                	xchg   %ax,%ax
  100539:	66 90                	xchg   %ax,%ax
  10053b:	66 90                	xchg   %ax,%ax
  10053d:	66 90                	xchg   %ax,%ax
  10053f:	90                   	nop

00100540 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
  100540:	f3 0f 1e fb          	endbr32 
  if(!lapic)
  100544:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100549:	85 c0                	test   %eax,%eax
  10054b:	0f 84 c7 00 00 00    	je     100618 <lapicinit+0xd8>
  lapic[index] = value;
  100551:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  100558:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10055b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10055e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  100565:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100568:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10056b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  100572:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  100575:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100578:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10057f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  100582:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100585:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10058c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10058f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100592:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  100599:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10059c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10059f:	8b 50 30             	mov    0x30(%eax),%edx
  1005a2:	c1 ea 10             	shr    $0x10,%edx
  1005a5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  1005ab:	75 73                	jne    100620 <lapicinit+0xe0>
  lapic[index] = value;
  1005ad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  1005b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005ba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005c7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005ce:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1005db:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005e1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1005e8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005ee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1005f5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1005f8:	8b 50 20             	mov    0x20(%eax),%edx
  1005fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1005ff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  100600:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
  100606:	80 e6 10             	and    $0x10,%dh
  100609:	75 f5                	jne    100600 <lapicinit+0xc0>
  lapic[index] = value;
  10060b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  100612:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100615:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  100618:	c3                   	ret    
  100619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
  100620:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  100627:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10062a:	8b 50 20             	mov    0x20(%eax),%edx
}
  10062d:	e9 7b ff ff ff       	jmp    1005ad <lapicinit+0x6d>
  100632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100640 <lapicid>:

int
lapicid(void)
{
  100640:	f3 0f 1e fb          	endbr32 
  if (!lapic)
  100644:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100649:	85 c0                	test   %eax,%eax
  10064b:	74 0b                	je     100658 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
  10064d:	8b 40 20             	mov    0x20(%eax),%eax
  100650:	c1 e8 18             	shr    $0x18,%eax
  100653:	c3                   	ret    
  100654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  100658:	31 c0                	xor    %eax,%eax
}
  10065a:	c3                   	ret    
  10065b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10065f:	90                   	nop

00100660 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  100660:	f3 0f 1e fb          	endbr32 
  if(lapic)
  100664:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100669:	85 c0                	test   %eax,%eax
  10066b:	74 0d                	je     10067a <lapiceoi+0x1a>
  lapic[index] = value;
  10066d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  100674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100677:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
  10067a:	c3                   	ret    
  10067b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10067f:	90                   	nop

00100680 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  100680:	f3 0f 1e fb          	endbr32 
  100684:	c3                   	ret    
  100685:	66 90                	xchg   %ax,%ax
  100687:	66 90                	xchg   %ax,%ax
  100689:	66 90                	xchg   %ax,%ax
  10068b:	66 90                	xchg   %ax,%ax
  10068d:	66 90                	xchg   %ax,%ax
  10068f:	90                   	nop

00100690 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  100690:	f3 0f 1e fb          	endbr32 
  100694:	55                   	push   %ebp
  100695:	89 e5                	mov    %esp,%ebp
  100697:	83 e4 f0             	and    $0xfffffff0,%esp
  mpinit();        // detect other processors
  10069a:	e8 a1 00 00 00       	call   100740 <mpinit>
  lapicinit();     // interrupt controller
  10069f:	e8 9c fe ff ff       	call   100540 <lapicinit>
  picinit();       // disable pic
  1006a4:	e8 57 02 00 00       	call   100900 <picinit>
  ioapicinit();    // another interrupt controller
  1006a9:	e8 a2 fd ff ff       	call   100450 <ioapicinit>
  uartinit();      // serial port
  1006ae:	e8 cd 02 00 00       	call   100980 <uartinit>
  mouseinit();
  1006b3:	e8 18 13 00 00       	call   1019d0 <mouseinit>
  tvinit();        // trap vectors
  1006b8:	e8 d3 06 00 00       	call   100d90 <tvinit>
  idtinit();       // load idt register
  1006bd:	e8 0e 07 00 00       	call   100dd0 <idtinit>


static inline void
sti(void)
{
  asm volatile("sti");
  1006c2:	fb                   	sti    
  1006c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006c7:	90                   	nop
}

static inline void
wfi(void)
{
  asm volatile("hlt");
  1006c8:	f4                   	hlt    
  1006c9:	eb fd                	jmp    1006c8 <main+0x38>
  1006cb:	66 90                	xchg   %ax,%ax
  1006cd:	66 90                	xchg   %ax,%ax
  1006cf:	90                   	nop

001006d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  1006d0:	55                   	push   %ebp
  1006d1:	89 e5                	mov    %esp,%ebp
  1006d3:	57                   	push   %edi
  1006d4:	56                   	push   %esi
  1006d5:	53                   	push   %ebx
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  e = addr+len;
  1006d6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
{
  1006d9:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
  1006dc:	39 d8                	cmp    %ebx,%eax
  1006de:	73 50                	jae    100730 <mpsearch1+0x60>
  1006e0:	89 c6                	mov    %eax,%esi
  1006e2:	eb 0a                	jmp    1006ee <mpsearch1+0x1e>
  1006e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006e8:	89 fe                	mov    %edi,%esi
  1006ea:	39 fb                	cmp    %edi,%ebx
  1006ec:	76 42                	jbe    100730 <mpsearch1+0x60>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1006ee:	83 ec 04             	sub    $0x4,%esp
  1006f1:	8d 7e 10             	lea    0x10(%esi),%edi
  1006f4:	6a 04                	push   $0x4
  1006f6:	68 8a 1b 10 00       	push   $0x101b8a
  1006fb:	56                   	push   %esi
  1006fc:	e8 cf 03 00 00       	call   100ad0 <memcmp>
  100701:	83 c4 10             	add    $0x10,%esp
  100704:	85 c0                	test   %eax,%eax
  100706:	75 e0                	jne    1006e8 <mpsearch1+0x18>
  100708:	89 f2                	mov    %esi,%edx
  10070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
  100710:	0f b6 0a             	movzbl (%edx),%ecx
  100713:	83 c2 01             	add    $0x1,%edx
  100716:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
  100718:	39 fa                	cmp    %edi,%edx
  10071a:	75 f4                	jne    100710 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  10071c:	84 c0                	test   %al,%al
  10071e:	75 c8                	jne    1006e8 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
  100720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100723:	89 f0                	mov    %esi,%eax
  100725:	5b                   	pop    %ebx
  100726:	5e                   	pop    %esi
  100727:	5f                   	pop    %edi
  100728:	5d                   	pop    %ebp
  100729:	c3                   	ret    
  10072a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
  100733:	31 f6                	xor    %esi,%esi
}
  100735:	5b                   	pop    %ebx
  100736:	89 f0                	mov    %esi,%eax
  100738:	5e                   	pop    %esi
  100739:	5f                   	pop    %edi
  10073a:	5d                   	pop    %ebp
  10073b:	c3                   	ret    
  10073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100740 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  100740:	f3 0f 1e fb          	endbr32 
  100744:	55                   	push   %ebp
  100745:	89 e5                	mov    %esp,%ebp
  100747:	57                   	push   %edi
  100748:	56                   	push   %esi
  100749:	53                   	push   %ebx
  10074a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  10074d:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  100754:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  10075b:	c1 e0 08             	shl    $0x8,%eax
  10075e:	09 d0                	or     %edx,%eax
  100760:	c1 e0 04             	shl    $0x4,%eax
  100763:	75 1b                	jne    100780 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100765:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  10076c:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  100773:	c1 e0 08             	shl    $0x8,%eax
  100776:	09 d0                	or     %edx,%eax
  100778:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
  10077b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
  100780:	ba 00 04 00 00       	mov    $0x400,%edx
  100785:	e8 46 ff ff ff       	call   1006d0 <mpsearch1>
  10078a:	89 c6                	mov    %eax,%esi
  10078c:	85 c0                	test   %eax,%eax
  10078e:	0f 84 cc 00 00 00    	je     100860 <mpinit+0x120>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100794:	8b 5e 04             	mov    0x4(%esi),%ebx
  100797:	85 db                	test   %ebx,%ebx
  100799:	0f 84 e1 00 00 00    	je     100880 <mpinit+0x140>
  if(memcmp(conf, "PCMP", 4) != 0)
  10079f:	83 ec 04             	sub    $0x4,%esp
  1007a2:	6a 04                	push   $0x4
  1007a4:	68 8f 1b 10 00       	push   $0x101b8f
  1007a9:	53                   	push   %ebx
  1007aa:	e8 21 03 00 00       	call   100ad0 <memcmp>
  1007af:	83 c4 10             	add    $0x10,%esp
  1007b2:	85 c0                	test   %eax,%eax
  1007b4:	0f 85 c6 00 00 00    	jne    100880 <mpinit+0x140>
  if(conf->version != 1 && conf->version != 4)
  1007ba:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  1007be:	3c 01                	cmp    $0x1,%al
  1007c0:	74 08                	je     1007ca <mpinit+0x8a>
  1007c2:	3c 04                	cmp    $0x4,%al
  1007c4:	0f 85 b6 00 00 00    	jne    100880 <mpinit+0x140>
  if(sum((uchar*)conf, conf->length) != 0)
  1007ca:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  for(i=0; i<len; i++)
  1007ce:	66 85 d2             	test   %dx,%dx
  1007d1:	0f 84 0b 01 00 00    	je     1008e2 <mpinit+0x1a2>
  1007d7:	0f b7 ca             	movzwl %dx,%ecx
  1007da:	89 d8                	mov    %ebx,%eax
  sum = 0;
  1007dc:	31 d2                	xor    %edx,%edx
  1007de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1007e1:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
  1007e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
  1007e8:	0f b6 08             	movzbl (%eax),%ecx
  1007eb:	83 c0 01             	add    $0x1,%eax
  1007ee:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
  1007f0:	39 f8                	cmp    %edi,%eax
  1007f2:	75 f4                	jne    1007e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
  1007f4:	84 d2                	test   %dl,%dl
  1007f6:	0f 85 84 00 00 00    	jne    100880 <mpinit+0x140>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  1007fc:	8b 43 24             	mov    0x24(%ebx),%eax
  ismp = 1;
  1007ff:	b9 01 00 00 00       	mov    $0x1,%ecx
  lapic = (uint*)conf->lapicaddr;
  100804:	a3 b0 34 10 00       	mov    %eax,0x1034b0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100809:	8d 43 2c             	lea    0x2c(%ebx),%eax
  10080c:	03 5d e4             	add    -0x1c(%ebp),%ebx
  10080f:	90                   	nop
  100810:	39 c3                	cmp    %eax,%ebx
  100812:	76 19                	jbe    10082d <mpinit+0xed>
    switch(*p){
  100814:	0f b6 10             	movzbl (%eax),%edx
  100817:	80 fa 02             	cmp    $0x2,%dl
  10081a:	0f 84 b0 00 00 00    	je     1008d0 <mpinit+0x190>
  100820:	77 6e                	ja     100890 <mpinit+0x150>
  100822:	84 d2                	test   %dl,%dl
  100824:	74 7a                	je     1008a0 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100826:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100829:	39 c3                	cmp    %eax,%ebx
  10082b:	77 e7                	ja     100814 <mpinit+0xd4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
  10082d:	85 c9                	test   %ecx,%ecx
  10082f:	0f 84 b9 00 00 00    	je     1008ee <mpinit+0x1ae>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
  100835:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  100839:	74 15                	je     100850 <mpinit+0x110>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10083b:	b8 70 00 00 00       	mov    $0x70,%eax
  100840:	ba 22 00 00 00       	mov    $0x22,%edx
  100845:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100846:	ba 23 00 00 00       	mov    $0x23,%edx
  10084b:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  10084c:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10084f:	ee                   	out    %al,(%dx)
  }
}
  100850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100853:	5b                   	pop    %ebx
  100854:	5e                   	pop    %esi
  100855:	5f                   	pop    %edi
  100856:	5d                   	pop    %ebp
  100857:	c3                   	ret    
  100858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10085f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
  100860:	ba 00 00 01 00       	mov    $0x10000,%edx
  100865:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  10086a:	e8 61 fe ff ff       	call   1006d0 <mpsearch1>
  10086f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100871:	85 c0                	test   %eax,%eax
  100873:	0f 85 1b ff ff ff    	jne    100794 <mpinit+0x54>
  100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
  100880:	83 ec 0c             	sub    $0xc,%esp
  100883:	68 94 1b 10 00       	push   $0x101b94
  100888:	e8 13 fa ff ff       	call   1002a0 <panic>
  10088d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  100890:	83 ea 03             	sub    $0x3,%edx
  100893:	80 fa 01             	cmp    $0x1,%dl
  100896:	76 8e                	jbe    100826 <mpinit+0xe6>
  100898:	31 c9                	xor    %ecx,%ecx
  10089a:	e9 71 ff ff ff       	jmp    100810 <mpinit+0xd0>
  10089f:	90                   	nop
      if(ncpu < NCPU) {
  1008a0:	8b 3d c0 34 10 00    	mov    0x1034c0,%edi
  1008a6:	83 ff 07             	cmp    $0x7,%edi
  1008a9:	7f 13                	jg     1008be <mpinit+0x17e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  1008ab:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
  1008af:	83 c7 01             	add    $0x1,%edi
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  1008b2:	88 97 b7 34 10 00    	mov    %dl,0x1034b7(%edi)
        ncpu++;
  1008b8:	89 3d c0 34 10 00    	mov    %edi,0x1034c0
      p += sizeof(struct mpproc);
  1008be:	83 c0 14             	add    $0x14,%eax
      continue;
  1008c1:	e9 4a ff ff ff       	jmp    100810 <mpinit+0xd0>
  1008c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1008cd:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
  1008d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
  1008d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
  1008d7:	88 15 b4 34 10 00    	mov    %dl,0x1034b4
      continue;
  1008dd:	e9 2e ff ff ff       	jmp    100810 <mpinit+0xd0>
  1008e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1008e9:	e9 0e ff ff ff       	jmp    1007fc <mpinit+0xbc>
    panic("Didn't find a suitable machine");
  1008ee:	83 ec 0c             	sub    $0xc,%esp
  1008f1:	68 ac 1b 10 00       	push   $0x101bac
  1008f6:	e8 a5 f9 ff ff       	call   1002a0 <panic>
  1008fb:	66 90                	xchg   %ax,%ax
  1008fd:	66 90                	xchg   %ax,%ax
  1008ff:	90                   	nop

00100900 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100900:	f3 0f 1e fb          	endbr32 
  100904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100909:	ba 21 00 00 00       	mov    $0x21,%edx
  10090e:	ee                   	out    %al,(%dx)
  10090f:	ba a1 00 00 00       	mov    $0xa1,%edx
  100914:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
  100915:	c3                   	ret    
  100916:	66 90                	xchg   %ax,%ax
  100918:	66 90                	xchg   %ax,%ax
  10091a:	66 90                	xchg   %ax,%ax
  10091c:	66 90                	xchg   %ax,%ax
  10091e:	66 90                	xchg   %ax,%ax

00100920 <uartgetc>:
}


static int
uartgetc(void)
{
  100920:	f3 0f 1e fb          	endbr32 
  if(!uart)
  100924:	a1 00 24 10 00       	mov    0x102400,%eax
  100929:	85 c0                	test   %eax,%eax
  10092b:	74 1b                	je     100948 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10092d:	ba fd 03 00 00       	mov    $0x3fd,%edx
  100932:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
  100933:	a8 01                	test   $0x1,%al
  100935:	74 11                	je     100948 <uartgetc+0x28>
  100937:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10093c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  10093d:	0f b6 c0             	movzbl %al,%eax
  100940:	c3                   	ret    
  100941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10094d:	c3                   	ret    
  10094e:	66 90                	xchg   %ax,%ax

00100950 <uartputc.part.0>:
uartputc(int c)
  100950:	55                   	push   %ebp
  100951:	b9 80 00 00 00       	mov    $0x80,%ecx
  100956:	ba fd 03 00 00       	mov    $0x3fd,%edx
  10095b:	89 e5                	mov    %esp,%ebp
  10095d:	53                   	push   %ebx
  10095e:	89 c3                	mov    %eax,%ebx
  100960:	eb 0b                	jmp    10096d <uartputc.part.0+0x1d>
  100962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100968:	83 e9 01             	sub    $0x1,%ecx
  10096b:	74 05                	je     100972 <uartputc.part.0+0x22>
  10096d:	ec                   	in     (%dx),%al
  10096e:	a8 20                	test   $0x20,%al
  100970:	74 f6                	je     100968 <uartputc.part.0+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100972:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100977:	89 d8                	mov    %ebx,%eax
  100979:	ee                   	out    %al,(%dx)
}
  10097a:	5b                   	pop    %ebx
  10097b:	5d                   	pop    %ebp
  10097c:	c3                   	ret    
  10097d:	8d 76 00             	lea    0x0(%esi),%esi

00100980 <uartinit>:
{
  100980:	f3 0f 1e fb          	endbr32 
  100984:	55                   	push   %ebp
  100985:	31 c9                	xor    %ecx,%ecx
  100987:	89 c8                	mov    %ecx,%eax
  100989:	89 e5                	mov    %esp,%ebp
  10098b:	57                   	push   %edi
  10098c:	56                   	push   %esi
  10098d:	53                   	push   %ebx
  10098e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
  100993:	89 da                	mov    %ebx,%edx
  100995:	83 ec 0c             	sub    $0xc,%esp
  100998:	ee                   	out    %al,(%dx)
  100999:	bf fb 03 00 00       	mov    $0x3fb,%edi
  10099e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  1009a3:	89 fa                	mov    %edi,%edx
  1009a5:	ee                   	out    %al,(%dx)
  1009a6:	b8 0c 00 00 00       	mov    $0xc,%eax
  1009ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
  1009b0:	ee                   	out    %al,(%dx)
  1009b1:	be f9 03 00 00       	mov    $0x3f9,%esi
  1009b6:	89 c8                	mov    %ecx,%eax
  1009b8:	89 f2                	mov    %esi,%edx
  1009ba:	ee                   	out    %al,(%dx)
  1009bb:	b8 03 00 00 00       	mov    $0x3,%eax
  1009c0:	89 fa                	mov    %edi,%edx
  1009c2:	ee                   	out    %al,(%dx)
  1009c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
  1009c8:	89 c8                	mov    %ecx,%eax
  1009ca:	ee                   	out    %al,(%dx)
  1009cb:	b8 01 00 00 00       	mov    $0x1,%eax
  1009d0:	89 f2                	mov    %esi,%edx
  1009d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1009d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1009d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
  1009d9:	3c ff                	cmp    $0xff,%al
  1009db:	74 47                	je     100a24 <uartinit+0xa4>
  uart = 1;
  1009dd:	c7 05 00 24 10 00 01 	movl   $0x1,0x102400
  1009e4:	00 00 00 
  1009e7:	89 da                	mov    %ebx,%edx
  1009e9:	ec                   	in     (%dx),%al
  1009ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
  1009ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
  1009f0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
  1009f3:	be cb 1b 10 00       	mov    $0x101bcb,%esi
  ioapicenable(IRQ_COM1, 0);
  1009f8:	6a 00                	push   $0x0
  1009fa:	6a 04                	push   $0x4
  1009fc:	e8 ff fa ff ff       	call   100500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
  100a01:	8b 1d 00 24 10 00    	mov    0x102400,%ebx
  100a07:	83 c4 10             	add    $0x10,%esp
  100a0a:	b8 78 00 00 00       	mov    $0x78,%eax
  100a0f:	90                   	nop
  if(!uart)
  100a10:	85 db                	test   %ebx,%ebx
  100a12:	74 05                	je     100a19 <uartinit+0x99>
  100a14:	e8 37 ff ff ff       	call   100950 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
  100a19:	0f be 46 01          	movsbl 0x1(%esi),%eax
  100a1d:	83 c6 01             	add    $0x1,%esi
  100a20:	84 c0                	test   %al,%al
  100a22:	75 ec                	jne    100a10 <uartinit+0x90>
}
  100a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100a27:	5b                   	pop    %ebx
  100a28:	5e                   	pop    %esi
  100a29:	5f                   	pop    %edi
  100a2a:	5d                   	pop    %ebp
  100a2b:	c3                   	ret    
  100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100a30 <uartputc>:
{
  100a30:	f3 0f 1e fb          	endbr32 
  100a34:	55                   	push   %ebp
  if(!uart)
  100a35:	8b 15 00 24 10 00    	mov    0x102400,%edx
{
  100a3b:	89 e5                	mov    %esp,%ebp
  100a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
  100a40:	85 d2                	test   %edx,%edx
  100a42:	74 0c                	je     100a50 <uartputc+0x20>
}
  100a44:	5d                   	pop    %ebp
  100a45:	e9 06 ff ff ff       	jmp    100950 <uartputc.part.0>
  100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100a50:	5d                   	pop    %ebp
  100a51:	c3                   	ret    
  100a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100a60 <uartintr>:

void
uartintr(void)
{
  100a60:	f3 0f 1e fb          	endbr32 
  100a64:	55                   	push   %ebp
  100a65:	89 e5                	mov    %esp,%ebp
  100a67:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
  100a6a:	68 20 09 10 00       	push   $0x100920
  100a6f:	e8 9c f8 ff ff       	call   100310 <consoleintr>
  100a74:	83 c4 10             	add    $0x10,%esp
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    
  100a79:	66 90                	xchg   %ax,%ax
  100a7b:	66 90                	xchg   %ax,%ax
  100a7d:	66 90                	xchg   %ax,%ax
  100a7f:	90                   	nop

00100a80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100a80:	f3 0f 1e fb          	endbr32 
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	57                   	push   %edi
  100a88:	8b 55 08             	mov    0x8(%ebp),%edx
  100a8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  100a8e:	53                   	push   %ebx
  100a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
  100a92:	89 d7                	mov    %edx,%edi
  100a94:	09 cf                	or     %ecx,%edi
  100a96:	83 e7 03             	and    $0x3,%edi
  100a99:	75 25                	jne    100ac0 <memset+0x40>
    c &= 0xFF;
  100a9b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100a9e:	c1 e0 18             	shl    $0x18,%eax
  100aa1:	89 fb                	mov    %edi,%ebx
  100aa3:	c1 e9 02             	shr    $0x2,%ecx
  100aa6:	c1 e3 10             	shl    $0x10,%ebx
  100aa9:	09 d8                	or     %ebx,%eax
  100aab:	09 f8                	or     %edi,%eax
  100aad:	c1 e7 08             	shl    $0x8,%edi
  100ab0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
  100ab2:	89 d7                	mov    %edx,%edi
  100ab4:	fc                   	cld    
  100ab5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
  100ab7:	5b                   	pop    %ebx
  100ab8:	89 d0                	mov    %edx,%eax
  100aba:	5f                   	pop    %edi
  100abb:	5d                   	pop    %ebp
  100abc:	c3                   	ret    
  100abd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
  100ac0:	89 d7                	mov    %edx,%edi
  100ac2:	fc                   	cld    
  100ac3:	f3 aa                	rep stos %al,%es:(%edi)
  100ac5:	5b                   	pop    %ebx
  100ac6:	89 d0                	mov    %edx,%eax
  100ac8:	5f                   	pop    %edi
  100ac9:	5d                   	pop    %ebp
  100aca:	c3                   	ret    
  100acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100acf:	90                   	nop

00100ad0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100ad0:	f3 0f 1e fb          	endbr32 
  100ad4:	55                   	push   %ebp
  100ad5:	89 e5                	mov    %esp,%ebp
  100ad7:	56                   	push   %esi
  100ad8:	8b 75 10             	mov    0x10(%ebp),%esi
  100adb:	8b 55 08             	mov    0x8(%ebp),%edx
  100ade:	53                   	push   %ebx
  100adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  100ae2:	85 f6                	test   %esi,%esi
  100ae4:	74 2a                	je     100b10 <memcmp+0x40>
  100ae6:	01 c6                	add    %eax,%esi
  100ae8:	eb 10                	jmp    100afa <memcmp+0x2a>
  100aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  100af0:	83 c0 01             	add    $0x1,%eax
  100af3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
  100af6:	39 f0                	cmp    %esi,%eax
  100af8:	74 16                	je     100b10 <memcmp+0x40>
    if(*s1 != *s2)
  100afa:	0f b6 0a             	movzbl (%edx),%ecx
  100afd:	0f b6 18             	movzbl (%eax),%ebx
  100b00:	38 d9                	cmp    %bl,%cl
  100b02:	74 ec                	je     100af0 <memcmp+0x20>
      return *s1 - *s2;
  100b04:	0f b6 c1             	movzbl %cl,%eax
  100b07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
  100b09:	5b                   	pop    %ebx
  100b0a:	5e                   	pop    %esi
  100b0b:	5d                   	pop    %ebp
  100b0c:	c3                   	ret    
  100b0d:	8d 76 00             	lea    0x0(%esi),%esi
  100b10:	5b                   	pop    %ebx
  return 0;
  100b11:	31 c0                	xor    %eax,%eax
}
  100b13:	5e                   	pop    %esi
  100b14:	5d                   	pop    %ebp
  100b15:	c3                   	ret    
  100b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b1d:	8d 76 00             	lea    0x0(%esi),%esi

00100b20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100b20:	f3 0f 1e fb          	endbr32 
  100b24:	55                   	push   %ebp
  100b25:	89 e5                	mov    %esp,%ebp
  100b27:	57                   	push   %edi
  100b28:	8b 55 08             	mov    0x8(%ebp),%edx
  100b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  100b2e:	56                   	push   %esi
  100b2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  100b32:	39 d6                	cmp    %edx,%esi
  100b34:	73 2a                	jae    100b60 <memmove+0x40>
  100b36:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
  100b39:	39 fa                	cmp    %edi,%edx
  100b3b:	73 23                	jae    100b60 <memmove+0x40>
  100b3d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
  100b40:	85 c9                	test   %ecx,%ecx
  100b42:	74 13                	je     100b57 <memmove+0x37>
  100b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
  100b48:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  100b4c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
  100b4f:	83 e8 01             	sub    $0x1,%eax
  100b52:	83 f8 ff             	cmp    $0xffffffff,%eax
  100b55:	75 f1                	jne    100b48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  100b57:	5e                   	pop    %esi
  100b58:	89 d0                	mov    %edx,%eax
  100b5a:	5f                   	pop    %edi
  100b5b:	5d                   	pop    %ebp
  100b5c:	c3                   	ret    
  100b5d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
  100b60:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
  100b63:	89 d7                	mov    %edx,%edi
  100b65:	85 c9                	test   %ecx,%ecx
  100b67:	74 ee                	je     100b57 <memmove+0x37>
  100b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
  100b70:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
  100b71:	39 f0                	cmp    %esi,%eax
  100b73:	75 fb                	jne    100b70 <memmove+0x50>
}
  100b75:	5e                   	pop    %esi
  100b76:	89 d0                	mov    %edx,%eax
  100b78:	5f                   	pop    %edi
  100b79:	5d                   	pop    %ebp
  100b7a:	c3                   	ret    
  100b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100b7f:	90                   	nop

00100b80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  100b80:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
  100b84:	eb 9a                	jmp    100b20 <memmove>
  100b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b8d:	8d 76 00             	lea    0x0(%esi),%esi

00100b90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  100b90:	f3 0f 1e fb          	endbr32 
  100b94:	55                   	push   %ebp
  100b95:	89 e5                	mov    %esp,%ebp
  100b97:	56                   	push   %esi
  100b98:	8b 75 10             	mov    0x10(%ebp),%esi
  100b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100b9e:	53                   	push   %ebx
  100b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
  100ba2:	85 f6                	test   %esi,%esi
  100ba4:	74 32                	je     100bd8 <strncmp+0x48>
  100ba6:	01 c6                	add    %eax,%esi
  100ba8:	eb 14                	jmp    100bbe <strncmp+0x2e>
  100baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100bb0:	38 da                	cmp    %bl,%dl
  100bb2:	75 14                	jne    100bc8 <strncmp+0x38>
    n--, p++, q++;
  100bb4:	83 c0 01             	add    $0x1,%eax
  100bb7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
  100bba:	39 f0                	cmp    %esi,%eax
  100bbc:	74 1a                	je     100bd8 <strncmp+0x48>
  100bbe:	0f b6 11             	movzbl (%ecx),%edx
  100bc1:	0f b6 18             	movzbl (%eax),%ebx
  100bc4:	84 d2                	test   %dl,%dl
  100bc6:	75 e8                	jne    100bb0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  100bc8:	0f b6 c2             	movzbl %dl,%eax
  100bcb:	29 d8                	sub    %ebx,%eax
}
  100bcd:	5b                   	pop    %ebx
  100bce:	5e                   	pop    %esi
  100bcf:	5d                   	pop    %ebp
  100bd0:	c3                   	ret    
  100bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100bd8:	5b                   	pop    %ebx
    return 0;
  100bd9:	31 c0                	xor    %eax,%eax
}
  100bdb:	5e                   	pop    %esi
  100bdc:	5d                   	pop    %ebp
  100bdd:	c3                   	ret    
  100bde:	66 90                	xchg   %ax,%ax

00100be0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  100be0:	f3 0f 1e fb          	endbr32 
  100be4:	55                   	push   %ebp
  100be5:	89 e5                	mov    %esp,%ebp
  100be7:	57                   	push   %edi
  100be8:	56                   	push   %esi
  100be9:	8b 75 08             	mov    0x8(%ebp),%esi
  100bec:	53                   	push   %ebx
  100bed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  100bf0:	89 f2                	mov    %esi,%edx
  100bf2:	eb 1b                	jmp    100c0f <strncpy+0x2f>
  100bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100bf8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  100bfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100bff:	83 c2 01             	add    $0x1,%edx
  100c02:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
  100c06:	89 f9                	mov    %edi,%ecx
  100c08:	88 4a ff             	mov    %cl,-0x1(%edx)
  100c0b:	84 c9                	test   %cl,%cl
  100c0d:	74 09                	je     100c18 <strncpy+0x38>
  100c0f:	89 c3                	mov    %eax,%ebx
  100c11:	83 e8 01             	sub    $0x1,%eax
  100c14:	85 db                	test   %ebx,%ebx
  100c16:	7f e0                	jg     100bf8 <strncpy+0x18>
    ;
  while(n-- > 0)
  100c18:	89 d1                	mov    %edx,%ecx
  100c1a:	85 c0                	test   %eax,%eax
  100c1c:	7e 15                	jle    100c33 <strncpy+0x53>
  100c1e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
  100c20:	83 c1 01             	add    $0x1,%ecx
  100c23:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
  100c27:	89 c8                	mov    %ecx,%eax
  100c29:	f7 d0                	not    %eax
  100c2b:	01 d0                	add    %edx,%eax
  100c2d:	01 d8                	add    %ebx,%eax
  100c2f:	85 c0                	test   %eax,%eax
  100c31:	7f ed                	jg     100c20 <strncpy+0x40>
  return os;
}
  100c33:	5b                   	pop    %ebx
  100c34:	89 f0                	mov    %esi,%eax
  100c36:	5e                   	pop    %esi
  100c37:	5f                   	pop    %edi
  100c38:	5d                   	pop    %ebp
  100c39:	c3                   	ret    
  100c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100c40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  100c40:	f3 0f 1e fb          	endbr32 
  100c44:	55                   	push   %ebp
  100c45:	89 e5                	mov    %esp,%ebp
  100c47:	56                   	push   %esi
  100c48:	8b 55 10             	mov    0x10(%ebp),%edx
  100c4b:	8b 75 08             	mov    0x8(%ebp),%esi
  100c4e:	53                   	push   %ebx
  100c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
  100c52:	85 d2                	test   %edx,%edx
  100c54:	7e 21                	jle    100c77 <safestrcpy+0x37>
  100c56:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
  100c5a:	89 f2                	mov    %esi,%edx
  100c5c:	eb 12                	jmp    100c70 <safestrcpy+0x30>
  100c5e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  100c60:	0f b6 08             	movzbl (%eax),%ecx
  100c63:	83 c0 01             	add    $0x1,%eax
  100c66:	83 c2 01             	add    $0x1,%edx
  100c69:	88 4a ff             	mov    %cl,-0x1(%edx)
  100c6c:	84 c9                	test   %cl,%cl
  100c6e:	74 04                	je     100c74 <safestrcpy+0x34>
  100c70:	39 d8                	cmp    %ebx,%eax
  100c72:	75 ec                	jne    100c60 <safestrcpy+0x20>
    ;
  *s = 0;
  100c74:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  100c77:	89 f0                	mov    %esi,%eax
  100c79:	5b                   	pop    %ebx
  100c7a:	5e                   	pop    %esi
  100c7b:	5d                   	pop    %ebp
  100c7c:	c3                   	ret    
  100c7d:	8d 76 00             	lea    0x0(%esi),%esi

00100c80 <strlen>:

int
strlen(const char *s)
{
  100c80:	f3 0f 1e fb          	endbr32 
  100c84:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  100c85:	31 c0                	xor    %eax,%eax
{
  100c87:	89 e5                	mov    %esp,%ebp
  100c89:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
  100c8c:	80 3a 00             	cmpb   $0x0,(%edx)
  100c8f:	74 10                	je     100ca1 <strlen+0x21>
  100c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100c98:	83 c0 01             	add    $0x1,%eax
  100c9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100c9f:	75 f7                	jne    100c98 <strlen+0x18>
    ;
  return n;
}
  100ca1:	5d                   	pop    %ebp
  100ca2:	c3                   	ret    
  100ca3:	66 90                	xchg   %ax,%ax
  100ca5:	66 90                	xchg   %ax,%ax
  100ca7:	66 90                	xchg   %ax,%ax
  100ca9:	66 90                	xchg   %ax,%ax
  100cab:	66 90                	xchg   %ax,%ax
  100cad:	66 90                	xchg   %ax,%ax
  100caf:	90                   	nop

00100cb0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  100cb0:	f3 0f 1e fb          	endbr32 
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	53                   	push   %ebx
  100cb8:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  100cbb:	9c                   	pushf  
  100cbc:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
  100cbd:	f6 c4 02             	test   $0x2,%ah
  100cc0:	75 40                	jne    100d02 <mycpu+0x52>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  100cc2:	e8 79 f9 ff ff       	call   100640 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  100cc7:	8b 1d c0 34 10 00    	mov    0x1034c0,%ebx
  100ccd:	85 db                	test   %ebx,%ebx
  100ccf:	7e 24                	jle    100cf5 <mycpu+0x45>
  100cd1:	31 d2                	xor    %edx,%edx
  100cd3:	eb 0a                	jmp    100cdf <mycpu+0x2f>
  100cd5:	8d 76 00             	lea    0x0(%esi),%esi
  100cd8:	83 c2 01             	add    $0x1,%edx
  100cdb:	39 da                	cmp    %ebx,%edx
  100cdd:	74 16                	je     100cf5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
  100cdf:	0f b6 8a b8 34 10 00 	movzbl 0x1034b8(%edx),%ecx
  100ce6:	39 c1                	cmp    %eax,%ecx
  100ce8:	75 ee                	jne    100cd8 <mycpu+0x28>
      return &cpus[i];
  }
  panic("unknown apicid\n");
  100cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return &cpus[i];
  100ced:	8d 82 b8 34 10 00    	lea    0x1034b8(%edx),%eax
  100cf3:	c9                   	leave  
  100cf4:	c3                   	ret    
  panic("unknown apicid\n");
  100cf5:	83 ec 0c             	sub    $0xc,%esp
  100cf8:	68 fa 1b 10 00       	push   $0x101bfa
  100cfd:	e8 9e f5 ff ff       	call   1002a0 <panic>
    panic("mycpu called with interrupts enabled\n");
  100d02:	83 ec 0c             	sub    $0xc,%esp
  100d05:	68 d4 1b 10 00       	push   $0x101bd4
  100d0a:	e8 91 f5 ff ff       	call   1002a0 <panic>
  100d0f:	90                   	nop

00100d10 <cpuid>:
cpuid() {
  100d10:	f3 0f 1e fb          	endbr32 
  100d14:	55                   	push   %ebp
  100d15:	89 e5                	mov    %esp,%ebp
  100d17:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  100d1a:	e8 91 ff ff ff       	call   100cb0 <mycpu>
}
  100d1f:	c9                   	leave  
  return mycpu()-cpus;
  100d20:	2d b8 34 10 00       	sub    $0x1034b8,%eax
}
  100d25:	c3                   	ret    
  100d26:	66 90                	xchg   %ax,%ax
  100d28:	66 90                	xchg   %ax,%ax
  100d2a:	66 90                	xchg   %ax,%ax
  100d2c:	66 90                	xchg   %ax,%ax
  100d2e:	66 90                	xchg   %ax,%ax

00100d30 <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  100d30:	f3 0f 1e fb          	endbr32 
  100d34:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  100d35:	31 d2                	xor    %edx,%edx
{
  100d37:	89 e5                	mov    %esp,%ebp
  100d39:	53                   	push   %ebx
  ebp = (uint*)v - 2;
  100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
{
  100d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
  100d40:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
  100d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100d47:	90                   	nop
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  100d48:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100d4b:	83 fb fd             	cmp    $0xfffffffd,%ebx
  100d4e:	77 18                	ja     100d68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  100d50:	8b 58 04             	mov    0x4(%eax),%ebx
  100d53:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
  100d56:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
  100d59:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
  100d5b:	83 fa 0a             	cmp    $0xa,%edx
  100d5e:	75 e8                	jne    100d48 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
  100d60:	5b                   	pop    %ebx
  100d61:	5d                   	pop    %ebp
  100d62:	c3                   	ret    
  100d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100d67:	90                   	nop
  for(; i < 10; i++)
  100d68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
  100d6b:	8d 51 28             	lea    0x28(%ecx),%edx
  100d6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
  100d70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  100d76:	83 c0 04             	add    $0x4,%eax
  100d79:	39 d0                	cmp    %edx,%eax
  100d7b:	75 f3                	jne    100d70 <getcallerpcs+0x40>
  100d7d:	5b                   	pop    %ebx
  100d7e:	5d                   	pop    %ebp
  100d7f:	c3                   	ret    

00100d80 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  100d80:	60                   	pusha  
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  100d81:	54                   	push   %esp
  call trap
  100d82:	e8 79 00 00 00       	call   100e00 <trap>
  addl $4, %esp
  100d87:	83 c4 04             	add    $0x4,%esp

00100d8a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  100d8a:	61                   	popa   
  addl $0x8, %esp  # trapno and errcode
  100d8b:	83 c4 08             	add    $0x8,%esp
  iret
  100d8e:	cf                   	iret   
  100d8f:	90                   	nop

00100d90 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  100d90:	f3 0f 1e fb          	endbr32 
  int i;

  for(i = 0; i < 256; i++)
  100d94:	31 c0                	xor    %eax,%eax
  100d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100d9d:	8d 76 00             	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  100da0:	8b 14 85 00 20 10 00 	mov    0x102000(,%eax,4),%edx
  100da7:	c7 04 c5 e2 34 10 00 	movl   $0x8e000008,0x1034e2(,%eax,8)
  100dae:	08 00 00 8e 
  100db2:	66 89 14 c5 e0 34 10 	mov    %dx,0x1034e0(,%eax,8)
  100db9:	00 
  100dba:	c1 ea 10             	shr    $0x10,%edx
  100dbd:	66 89 14 c5 e6 34 10 	mov    %dx,0x1034e6(,%eax,8)
  100dc4:	00 
  for(i = 0; i < 256; i++)
  100dc5:	83 c0 01             	add    $0x1,%eax
  100dc8:	3d 00 01 00 00       	cmp    $0x100,%eax
  100dcd:	75 d1                	jne    100da0 <tvinit+0x10>
}
  100dcf:	c3                   	ret    

00100dd0 <idtinit>:

void
idtinit(void)
{
  100dd0:	f3 0f 1e fb          	endbr32 
  100dd4:	55                   	push   %ebp
  pd[0] = size-1;
  100dd5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
  100dda:	89 e5                	mov    %esp,%ebp
  100ddc:	83 ec 10             	sub    $0x10,%esp
  100ddf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  100de3:	b8 e0 34 10 00       	mov    $0x1034e0,%eax
  100de8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  100dec:	c1 e8 10             	shr    $0x10,%eax
  100def:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  100df3:	8d 45 fa             	lea    -0x6(%ebp),%eax
  100df6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  100df9:	c9                   	leave  
  100dfa:	c3                   	ret    
  100dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100dff:	90                   	nop

00100e00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  100e00:	f3 0f 1e fb          	endbr32 
  100e04:	55                   	push   %ebp
  100e05:	89 e5                	mov    %esp,%ebp
  100e07:	57                   	push   %edi
  100e08:	56                   	push   %esi
  100e09:	53                   	push   %ebx
  100e0a:	83 ec 0c             	sub    $0xc,%esp
  100e0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  switch(tf->trapno){
  100e10:	8b 43 20             	mov    0x20(%ebx),%eax
  100e13:	83 e8 20             	sub    $0x20,%eax
  100e16:	83 f8 1f             	cmp    $0x1f,%eax
  100e19:	77 78                	ja     100e93 <trap+0x93>
  100e1b:	3e ff 24 85 68 1c 10 	notrack jmp *0x101c68(,%eax,4)
  100e22:	00 
  100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100e27:	90                   	nop
    mouseintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  100e28:	8b 73 28             	mov    0x28(%ebx),%esi
  100e2b:	0f b7 5b 2c          	movzwl 0x2c(%ebx),%ebx
  100e2f:	e8 dc fe ff ff       	call   100d10 <cpuid>
  100e34:	56                   	push   %esi
  100e35:	53                   	push   %ebx
  100e36:	50                   	push   %eax
  100e37:	68 0c 1c 10 00       	push   $0x101c0c
  100e3c:	e8 af f2 ff ff       	call   1000f0 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
  100e41:	83 c4 10             	add    $0x10,%esp
  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  }
}
  100e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e47:	5b                   	pop    %ebx
  100e48:	5e                   	pop    %esi
  100e49:	5f                   	pop    %edi
  100e4a:	5d                   	pop    %ebp
    lapiceoi();
  100e4b:	e9 10 f8 ff ff       	jmp    100660 <lapiceoi>
    mouseintr();
  100e50:	e8 2b 0c 00 00       	call   101a80 <mouseintr>
}
  100e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e58:	5b                   	pop    %ebx
  100e59:	5e                   	pop    %esi
  100e5a:	5f                   	pop    %edi
  100e5b:	5d                   	pop    %ebp
    lapiceoi();
  100e5c:	e9 ff f7 ff ff       	jmp    100660 <lapiceoi>
  100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
  100e68:	e8 f3 fb ff ff       	call   100a60 <uartintr>
}
  100e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e70:	5b                   	pop    %ebx
  100e71:	5e                   	pop    %esi
  100e72:	5f                   	pop    %edi
  100e73:	5d                   	pop    %ebp
    lapiceoi();
  100e74:	e9 e7 f7 ff ff       	jmp    100660 <lapiceoi>
  100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ticks++;
  100e80:	83 05 e0 3c 10 00 01 	addl   $0x1,0x103ce0
}
  100e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e8a:	5b                   	pop    %ebx
  100e8b:	5e                   	pop    %esi
  100e8c:	5f                   	pop    %edi
  100e8d:	5d                   	pop    %ebp
    lapiceoi();
  100e8e:	e9 cd f7 ff ff       	jmp    100660 <lapiceoi>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  100e93:	0f 20 d7             	mov    %cr2,%edi
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  100e96:	8b 73 28             	mov    0x28(%ebx),%esi
  100e99:	e8 72 fe ff ff       	call   100d10 <cpuid>
  100e9e:	83 ec 0c             	sub    $0xc,%esp
  100ea1:	57                   	push   %edi
  100ea2:	56                   	push   %esi
  100ea3:	50                   	push   %eax
  100ea4:	ff 73 20             	push   0x20(%ebx)
  100ea7:	68 30 1c 10 00       	push   $0x101c30
  100eac:	e8 3f f2 ff ff       	call   1000f0 <cprintf>
    panic("trap");
  100eb1:	83 c4 14             	add    $0x14,%esp
  100eb4:	68 62 1c 10 00       	push   $0x101c62
  100eb9:	e8 e2 f3 ff ff       	call   1002a0 <panic>

00100ebe <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  100ebe:	6a 00                	push   $0x0
  pushl $0
  100ec0:	6a 00                	push   $0x0
  jmp alltraps
  100ec2:	e9 b9 fe ff ff       	jmp    100d80 <alltraps>

00100ec7 <vector1>:
.globl vector1
vector1:
  pushl $0
  100ec7:	6a 00                	push   $0x0
  pushl $1
  100ec9:	6a 01                	push   $0x1
  jmp alltraps
  100ecb:	e9 b0 fe ff ff       	jmp    100d80 <alltraps>

00100ed0 <vector2>:
.globl vector2
vector2:
  pushl $0
  100ed0:	6a 00                	push   $0x0
  pushl $2
  100ed2:	6a 02                	push   $0x2
  jmp alltraps
  100ed4:	e9 a7 fe ff ff       	jmp    100d80 <alltraps>

00100ed9 <vector3>:
.globl vector3
vector3:
  pushl $0
  100ed9:	6a 00                	push   $0x0
  pushl $3
  100edb:	6a 03                	push   $0x3
  jmp alltraps
  100edd:	e9 9e fe ff ff       	jmp    100d80 <alltraps>

00100ee2 <vector4>:
.globl vector4
vector4:
  pushl $0
  100ee2:	6a 00                	push   $0x0
  pushl $4
  100ee4:	6a 04                	push   $0x4
  jmp alltraps
  100ee6:	e9 95 fe ff ff       	jmp    100d80 <alltraps>

00100eeb <vector5>:
.globl vector5
vector5:
  pushl $0
  100eeb:	6a 00                	push   $0x0
  pushl $5
  100eed:	6a 05                	push   $0x5
  jmp alltraps
  100eef:	e9 8c fe ff ff       	jmp    100d80 <alltraps>

00100ef4 <vector6>:
.globl vector6
vector6:
  pushl $0
  100ef4:	6a 00                	push   $0x0
  pushl $6
  100ef6:	6a 06                	push   $0x6
  jmp alltraps
  100ef8:	e9 83 fe ff ff       	jmp    100d80 <alltraps>

00100efd <vector7>:
.globl vector7
vector7:
  pushl $0
  100efd:	6a 00                	push   $0x0
  pushl $7
  100eff:	6a 07                	push   $0x7
  jmp alltraps
  100f01:	e9 7a fe ff ff       	jmp    100d80 <alltraps>

00100f06 <vector8>:
.globl vector8
vector8:
  pushl $8
  100f06:	6a 08                	push   $0x8
  jmp alltraps
  100f08:	e9 73 fe ff ff       	jmp    100d80 <alltraps>

00100f0d <vector9>:
.globl vector9
vector9:
  pushl $0
  100f0d:	6a 00                	push   $0x0
  pushl $9
  100f0f:	6a 09                	push   $0x9
  jmp alltraps
  100f11:	e9 6a fe ff ff       	jmp    100d80 <alltraps>

00100f16 <vector10>:
.globl vector10
vector10:
  pushl $10
  100f16:	6a 0a                	push   $0xa
  jmp alltraps
  100f18:	e9 63 fe ff ff       	jmp    100d80 <alltraps>

00100f1d <vector11>:
.globl vector11
vector11:
  pushl $11
  100f1d:	6a 0b                	push   $0xb
  jmp alltraps
  100f1f:	e9 5c fe ff ff       	jmp    100d80 <alltraps>

00100f24 <vector12>:
.globl vector12
vector12:
  pushl $12
  100f24:	6a 0c                	push   $0xc
  jmp alltraps
  100f26:	e9 55 fe ff ff       	jmp    100d80 <alltraps>

00100f2b <vector13>:
.globl vector13
vector13:
  pushl $13
  100f2b:	6a 0d                	push   $0xd
  jmp alltraps
  100f2d:	e9 4e fe ff ff       	jmp    100d80 <alltraps>

00100f32 <vector14>:
.globl vector14
vector14:
  pushl $14
  100f32:	6a 0e                	push   $0xe
  jmp alltraps
  100f34:	e9 47 fe ff ff       	jmp    100d80 <alltraps>

00100f39 <vector15>:
.globl vector15
vector15:
  pushl $0
  100f39:	6a 00                	push   $0x0
  pushl $15
  100f3b:	6a 0f                	push   $0xf
  jmp alltraps
  100f3d:	e9 3e fe ff ff       	jmp    100d80 <alltraps>

00100f42 <vector16>:
.globl vector16
vector16:
  pushl $0
  100f42:	6a 00                	push   $0x0
  pushl $16
  100f44:	6a 10                	push   $0x10
  jmp alltraps
  100f46:	e9 35 fe ff ff       	jmp    100d80 <alltraps>

00100f4b <vector17>:
.globl vector17
vector17:
  pushl $17
  100f4b:	6a 11                	push   $0x11
  jmp alltraps
  100f4d:	e9 2e fe ff ff       	jmp    100d80 <alltraps>

00100f52 <vector18>:
.globl vector18
vector18:
  pushl $0
  100f52:	6a 00                	push   $0x0
  pushl $18
  100f54:	6a 12                	push   $0x12
  jmp alltraps
  100f56:	e9 25 fe ff ff       	jmp    100d80 <alltraps>

00100f5b <vector19>:
.globl vector19
vector19:
  pushl $0
  100f5b:	6a 00                	push   $0x0
  pushl $19
  100f5d:	6a 13                	push   $0x13
  jmp alltraps
  100f5f:	e9 1c fe ff ff       	jmp    100d80 <alltraps>

00100f64 <vector20>:
.globl vector20
vector20:
  pushl $0
  100f64:	6a 00                	push   $0x0
  pushl $20
  100f66:	6a 14                	push   $0x14
  jmp alltraps
  100f68:	e9 13 fe ff ff       	jmp    100d80 <alltraps>

00100f6d <vector21>:
.globl vector21
vector21:
  pushl $0
  100f6d:	6a 00                	push   $0x0
  pushl $21
  100f6f:	6a 15                	push   $0x15
  jmp alltraps
  100f71:	e9 0a fe ff ff       	jmp    100d80 <alltraps>

00100f76 <vector22>:
.globl vector22
vector22:
  pushl $0
  100f76:	6a 00                	push   $0x0
  pushl $22
  100f78:	6a 16                	push   $0x16
  jmp alltraps
  100f7a:	e9 01 fe ff ff       	jmp    100d80 <alltraps>

00100f7f <vector23>:
.globl vector23
vector23:
  pushl $0
  100f7f:	6a 00                	push   $0x0
  pushl $23
  100f81:	6a 17                	push   $0x17
  jmp alltraps
  100f83:	e9 f8 fd ff ff       	jmp    100d80 <alltraps>

00100f88 <vector24>:
.globl vector24
vector24:
  pushl $0
  100f88:	6a 00                	push   $0x0
  pushl $24
  100f8a:	6a 18                	push   $0x18
  jmp alltraps
  100f8c:	e9 ef fd ff ff       	jmp    100d80 <alltraps>

00100f91 <vector25>:
.globl vector25
vector25:
  pushl $0
  100f91:	6a 00                	push   $0x0
  pushl $25
  100f93:	6a 19                	push   $0x19
  jmp alltraps
  100f95:	e9 e6 fd ff ff       	jmp    100d80 <alltraps>

00100f9a <vector26>:
.globl vector26
vector26:
  pushl $0
  100f9a:	6a 00                	push   $0x0
  pushl $26
  100f9c:	6a 1a                	push   $0x1a
  jmp alltraps
  100f9e:	e9 dd fd ff ff       	jmp    100d80 <alltraps>

00100fa3 <vector27>:
.globl vector27
vector27:
  pushl $0
  100fa3:	6a 00                	push   $0x0
  pushl $27
  100fa5:	6a 1b                	push   $0x1b
  jmp alltraps
  100fa7:	e9 d4 fd ff ff       	jmp    100d80 <alltraps>

00100fac <vector28>:
.globl vector28
vector28:
  pushl $0
  100fac:	6a 00                	push   $0x0
  pushl $28
  100fae:	6a 1c                	push   $0x1c
  jmp alltraps
  100fb0:	e9 cb fd ff ff       	jmp    100d80 <alltraps>

00100fb5 <vector29>:
.globl vector29
vector29:
  pushl $0
  100fb5:	6a 00                	push   $0x0
  pushl $29
  100fb7:	6a 1d                	push   $0x1d
  jmp alltraps
  100fb9:	e9 c2 fd ff ff       	jmp    100d80 <alltraps>

00100fbe <vector30>:
.globl vector30
vector30:
  pushl $0
  100fbe:	6a 00                	push   $0x0
  pushl $30
  100fc0:	6a 1e                	push   $0x1e
  jmp alltraps
  100fc2:	e9 b9 fd ff ff       	jmp    100d80 <alltraps>

00100fc7 <vector31>:
.globl vector31
vector31:
  pushl $0
  100fc7:	6a 00                	push   $0x0
  pushl $31
  100fc9:	6a 1f                	push   $0x1f
  jmp alltraps
  100fcb:	e9 b0 fd ff ff       	jmp    100d80 <alltraps>

00100fd0 <vector32>:
.globl vector32
vector32:
  pushl $0
  100fd0:	6a 00                	push   $0x0
  pushl $32
  100fd2:	6a 20                	push   $0x20
  jmp alltraps
  100fd4:	e9 a7 fd ff ff       	jmp    100d80 <alltraps>

00100fd9 <vector33>:
.globl vector33
vector33:
  pushl $0
  100fd9:	6a 00                	push   $0x0
  pushl $33
  100fdb:	6a 21                	push   $0x21
  jmp alltraps
  100fdd:	e9 9e fd ff ff       	jmp    100d80 <alltraps>

00100fe2 <vector34>:
.globl vector34
vector34:
  pushl $0
  100fe2:	6a 00                	push   $0x0
  pushl $34
  100fe4:	6a 22                	push   $0x22
  jmp alltraps
  100fe6:	e9 95 fd ff ff       	jmp    100d80 <alltraps>

00100feb <vector35>:
.globl vector35
vector35:
  pushl $0
  100feb:	6a 00                	push   $0x0
  pushl $35
  100fed:	6a 23                	push   $0x23
  jmp alltraps
  100fef:	e9 8c fd ff ff       	jmp    100d80 <alltraps>

00100ff4 <vector36>:
.globl vector36
vector36:
  pushl $0
  100ff4:	6a 00                	push   $0x0
  pushl $36
  100ff6:	6a 24                	push   $0x24
  jmp alltraps
  100ff8:	e9 83 fd ff ff       	jmp    100d80 <alltraps>

00100ffd <vector37>:
.globl vector37
vector37:
  pushl $0
  100ffd:	6a 00                	push   $0x0
  pushl $37
  100fff:	6a 25                	push   $0x25
  jmp alltraps
  101001:	e9 7a fd ff ff       	jmp    100d80 <alltraps>

00101006 <vector38>:
.globl vector38
vector38:
  pushl $0
  101006:	6a 00                	push   $0x0
  pushl $38
  101008:	6a 26                	push   $0x26
  jmp alltraps
  10100a:	e9 71 fd ff ff       	jmp    100d80 <alltraps>

0010100f <vector39>:
.globl vector39
vector39:
  pushl $0
  10100f:	6a 00                	push   $0x0
  pushl $39
  101011:	6a 27                	push   $0x27
  jmp alltraps
  101013:	e9 68 fd ff ff       	jmp    100d80 <alltraps>

00101018 <vector40>:
.globl vector40
vector40:
  pushl $0
  101018:	6a 00                	push   $0x0
  pushl $40
  10101a:	6a 28                	push   $0x28
  jmp alltraps
  10101c:	e9 5f fd ff ff       	jmp    100d80 <alltraps>

00101021 <vector41>:
.globl vector41
vector41:
  pushl $0
  101021:	6a 00                	push   $0x0
  pushl $41
  101023:	6a 29                	push   $0x29
  jmp alltraps
  101025:	e9 56 fd ff ff       	jmp    100d80 <alltraps>

0010102a <vector42>:
.globl vector42
vector42:
  pushl $0
  10102a:	6a 00                	push   $0x0
  pushl $42
  10102c:	6a 2a                	push   $0x2a
  jmp alltraps
  10102e:	e9 4d fd ff ff       	jmp    100d80 <alltraps>

00101033 <vector43>:
.globl vector43
vector43:
  pushl $0
  101033:	6a 00                	push   $0x0
  pushl $43
  101035:	6a 2b                	push   $0x2b
  jmp alltraps
  101037:	e9 44 fd ff ff       	jmp    100d80 <alltraps>

0010103c <vector44>:
.globl vector44
vector44:
  pushl $0
  10103c:	6a 00                	push   $0x0
  pushl $44
  10103e:	6a 2c                	push   $0x2c
  jmp alltraps
  101040:	e9 3b fd ff ff       	jmp    100d80 <alltraps>

00101045 <vector45>:
.globl vector45
vector45:
  pushl $0
  101045:	6a 00                	push   $0x0
  pushl $45
  101047:	6a 2d                	push   $0x2d
  jmp alltraps
  101049:	e9 32 fd ff ff       	jmp    100d80 <alltraps>

0010104e <vector46>:
.globl vector46
vector46:
  pushl $0
  10104e:	6a 00                	push   $0x0
  pushl $46
  101050:	6a 2e                	push   $0x2e
  jmp alltraps
  101052:	e9 29 fd ff ff       	jmp    100d80 <alltraps>

00101057 <vector47>:
.globl vector47
vector47:
  pushl $0
  101057:	6a 00                	push   $0x0
  pushl $47
  101059:	6a 2f                	push   $0x2f
  jmp alltraps
  10105b:	e9 20 fd ff ff       	jmp    100d80 <alltraps>

00101060 <vector48>:
.globl vector48
vector48:
  pushl $0
  101060:	6a 00                	push   $0x0
  pushl $48
  101062:	6a 30                	push   $0x30
  jmp alltraps
  101064:	e9 17 fd ff ff       	jmp    100d80 <alltraps>

00101069 <vector49>:
.globl vector49
vector49:
  pushl $0
  101069:	6a 00                	push   $0x0
  pushl $49
  10106b:	6a 31                	push   $0x31
  jmp alltraps
  10106d:	e9 0e fd ff ff       	jmp    100d80 <alltraps>

00101072 <vector50>:
.globl vector50
vector50:
  pushl $0
  101072:	6a 00                	push   $0x0
  pushl $50
  101074:	6a 32                	push   $0x32
  jmp alltraps
  101076:	e9 05 fd ff ff       	jmp    100d80 <alltraps>

0010107b <vector51>:
.globl vector51
vector51:
  pushl $0
  10107b:	6a 00                	push   $0x0
  pushl $51
  10107d:	6a 33                	push   $0x33
  jmp alltraps
  10107f:	e9 fc fc ff ff       	jmp    100d80 <alltraps>

00101084 <vector52>:
.globl vector52
vector52:
  pushl $0
  101084:	6a 00                	push   $0x0
  pushl $52
  101086:	6a 34                	push   $0x34
  jmp alltraps
  101088:	e9 f3 fc ff ff       	jmp    100d80 <alltraps>

0010108d <vector53>:
.globl vector53
vector53:
  pushl $0
  10108d:	6a 00                	push   $0x0
  pushl $53
  10108f:	6a 35                	push   $0x35
  jmp alltraps
  101091:	e9 ea fc ff ff       	jmp    100d80 <alltraps>

00101096 <vector54>:
.globl vector54
vector54:
  pushl $0
  101096:	6a 00                	push   $0x0
  pushl $54
  101098:	6a 36                	push   $0x36
  jmp alltraps
  10109a:	e9 e1 fc ff ff       	jmp    100d80 <alltraps>

0010109f <vector55>:
.globl vector55
vector55:
  pushl $0
  10109f:	6a 00                	push   $0x0
  pushl $55
  1010a1:	6a 37                	push   $0x37
  jmp alltraps
  1010a3:	e9 d8 fc ff ff       	jmp    100d80 <alltraps>

001010a8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1010a8:	6a 00                	push   $0x0
  pushl $56
  1010aa:	6a 38                	push   $0x38
  jmp alltraps
  1010ac:	e9 cf fc ff ff       	jmp    100d80 <alltraps>

001010b1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1010b1:	6a 00                	push   $0x0
  pushl $57
  1010b3:	6a 39                	push   $0x39
  jmp alltraps
  1010b5:	e9 c6 fc ff ff       	jmp    100d80 <alltraps>

001010ba <vector58>:
.globl vector58
vector58:
  pushl $0
  1010ba:	6a 00                	push   $0x0
  pushl $58
  1010bc:	6a 3a                	push   $0x3a
  jmp alltraps
  1010be:	e9 bd fc ff ff       	jmp    100d80 <alltraps>

001010c3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1010c3:	6a 00                	push   $0x0
  pushl $59
  1010c5:	6a 3b                	push   $0x3b
  jmp alltraps
  1010c7:	e9 b4 fc ff ff       	jmp    100d80 <alltraps>

001010cc <vector60>:
.globl vector60
vector60:
  pushl $0
  1010cc:	6a 00                	push   $0x0
  pushl $60
  1010ce:	6a 3c                	push   $0x3c
  jmp alltraps
  1010d0:	e9 ab fc ff ff       	jmp    100d80 <alltraps>

001010d5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1010d5:	6a 00                	push   $0x0
  pushl $61
  1010d7:	6a 3d                	push   $0x3d
  jmp alltraps
  1010d9:	e9 a2 fc ff ff       	jmp    100d80 <alltraps>

001010de <vector62>:
.globl vector62
vector62:
  pushl $0
  1010de:	6a 00                	push   $0x0
  pushl $62
  1010e0:	6a 3e                	push   $0x3e
  jmp alltraps
  1010e2:	e9 99 fc ff ff       	jmp    100d80 <alltraps>

001010e7 <vector63>:
.globl vector63
vector63:
  pushl $0
  1010e7:	6a 00                	push   $0x0
  pushl $63
  1010e9:	6a 3f                	push   $0x3f
  jmp alltraps
  1010eb:	e9 90 fc ff ff       	jmp    100d80 <alltraps>

001010f0 <vector64>:
.globl vector64
vector64:
  pushl $0
  1010f0:	6a 00                	push   $0x0
  pushl $64
  1010f2:	6a 40                	push   $0x40
  jmp alltraps
  1010f4:	e9 87 fc ff ff       	jmp    100d80 <alltraps>

001010f9 <vector65>:
.globl vector65
vector65:
  pushl $0
  1010f9:	6a 00                	push   $0x0
  pushl $65
  1010fb:	6a 41                	push   $0x41
  jmp alltraps
  1010fd:	e9 7e fc ff ff       	jmp    100d80 <alltraps>

00101102 <vector66>:
.globl vector66
vector66:
  pushl $0
  101102:	6a 00                	push   $0x0
  pushl $66
  101104:	6a 42                	push   $0x42
  jmp alltraps
  101106:	e9 75 fc ff ff       	jmp    100d80 <alltraps>

0010110b <vector67>:
.globl vector67
vector67:
  pushl $0
  10110b:	6a 00                	push   $0x0
  pushl $67
  10110d:	6a 43                	push   $0x43
  jmp alltraps
  10110f:	e9 6c fc ff ff       	jmp    100d80 <alltraps>

00101114 <vector68>:
.globl vector68
vector68:
  pushl $0
  101114:	6a 00                	push   $0x0
  pushl $68
  101116:	6a 44                	push   $0x44
  jmp alltraps
  101118:	e9 63 fc ff ff       	jmp    100d80 <alltraps>

0010111d <vector69>:
.globl vector69
vector69:
  pushl $0
  10111d:	6a 00                	push   $0x0
  pushl $69
  10111f:	6a 45                	push   $0x45
  jmp alltraps
  101121:	e9 5a fc ff ff       	jmp    100d80 <alltraps>

00101126 <vector70>:
.globl vector70
vector70:
  pushl $0
  101126:	6a 00                	push   $0x0
  pushl $70
  101128:	6a 46                	push   $0x46
  jmp alltraps
  10112a:	e9 51 fc ff ff       	jmp    100d80 <alltraps>

0010112f <vector71>:
.globl vector71
vector71:
  pushl $0
  10112f:	6a 00                	push   $0x0
  pushl $71
  101131:	6a 47                	push   $0x47
  jmp alltraps
  101133:	e9 48 fc ff ff       	jmp    100d80 <alltraps>

00101138 <vector72>:
.globl vector72
vector72:
  pushl $0
  101138:	6a 00                	push   $0x0
  pushl $72
  10113a:	6a 48                	push   $0x48
  jmp alltraps
  10113c:	e9 3f fc ff ff       	jmp    100d80 <alltraps>

00101141 <vector73>:
.globl vector73
vector73:
  pushl $0
  101141:	6a 00                	push   $0x0
  pushl $73
  101143:	6a 49                	push   $0x49
  jmp alltraps
  101145:	e9 36 fc ff ff       	jmp    100d80 <alltraps>

0010114a <vector74>:
.globl vector74
vector74:
  pushl $0
  10114a:	6a 00                	push   $0x0
  pushl $74
  10114c:	6a 4a                	push   $0x4a
  jmp alltraps
  10114e:	e9 2d fc ff ff       	jmp    100d80 <alltraps>

00101153 <vector75>:
.globl vector75
vector75:
  pushl $0
  101153:	6a 00                	push   $0x0
  pushl $75
  101155:	6a 4b                	push   $0x4b
  jmp alltraps
  101157:	e9 24 fc ff ff       	jmp    100d80 <alltraps>

0010115c <vector76>:
.globl vector76
vector76:
  pushl $0
  10115c:	6a 00                	push   $0x0
  pushl $76
  10115e:	6a 4c                	push   $0x4c
  jmp alltraps
  101160:	e9 1b fc ff ff       	jmp    100d80 <alltraps>

00101165 <vector77>:
.globl vector77
vector77:
  pushl $0
  101165:	6a 00                	push   $0x0
  pushl $77
  101167:	6a 4d                	push   $0x4d
  jmp alltraps
  101169:	e9 12 fc ff ff       	jmp    100d80 <alltraps>

0010116e <vector78>:
.globl vector78
vector78:
  pushl $0
  10116e:	6a 00                	push   $0x0
  pushl $78
  101170:	6a 4e                	push   $0x4e
  jmp alltraps
  101172:	e9 09 fc ff ff       	jmp    100d80 <alltraps>

00101177 <vector79>:
.globl vector79
vector79:
  pushl $0
  101177:	6a 00                	push   $0x0
  pushl $79
  101179:	6a 4f                	push   $0x4f
  jmp alltraps
  10117b:	e9 00 fc ff ff       	jmp    100d80 <alltraps>

00101180 <vector80>:
.globl vector80
vector80:
  pushl $0
  101180:	6a 00                	push   $0x0
  pushl $80
  101182:	6a 50                	push   $0x50
  jmp alltraps
  101184:	e9 f7 fb ff ff       	jmp    100d80 <alltraps>

00101189 <vector81>:
.globl vector81
vector81:
  pushl $0
  101189:	6a 00                	push   $0x0
  pushl $81
  10118b:	6a 51                	push   $0x51
  jmp alltraps
  10118d:	e9 ee fb ff ff       	jmp    100d80 <alltraps>

00101192 <vector82>:
.globl vector82
vector82:
  pushl $0
  101192:	6a 00                	push   $0x0
  pushl $82
  101194:	6a 52                	push   $0x52
  jmp alltraps
  101196:	e9 e5 fb ff ff       	jmp    100d80 <alltraps>

0010119b <vector83>:
.globl vector83
vector83:
  pushl $0
  10119b:	6a 00                	push   $0x0
  pushl $83
  10119d:	6a 53                	push   $0x53
  jmp alltraps
  10119f:	e9 dc fb ff ff       	jmp    100d80 <alltraps>

001011a4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1011a4:	6a 00                	push   $0x0
  pushl $84
  1011a6:	6a 54                	push   $0x54
  jmp alltraps
  1011a8:	e9 d3 fb ff ff       	jmp    100d80 <alltraps>

001011ad <vector85>:
.globl vector85
vector85:
  pushl $0
  1011ad:	6a 00                	push   $0x0
  pushl $85
  1011af:	6a 55                	push   $0x55
  jmp alltraps
  1011b1:	e9 ca fb ff ff       	jmp    100d80 <alltraps>

001011b6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1011b6:	6a 00                	push   $0x0
  pushl $86
  1011b8:	6a 56                	push   $0x56
  jmp alltraps
  1011ba:	e9 c1 fb ff ff       	jmp    100d80 <alltraps>

001011bf <vector87>:
.globl vector87
vector87:
  pushl $0
  1011bf:	6a 00                	push   $0x0
  pushl $87
  1011c1:	6a 57                	push   $0x57
  jmp alltraps
  1011c3:	e9 b8 fb ff ff       	jmp    100d80 <alltraps>

001011c8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1011c8:	6a 00                	push   $0x0
  pushl $88
  1011ca:	6a 58                	push   $0x58
  jmp alltraps
  1011cc:	e9 af fb ff ff       	jmp    100d80 <alltraps>

001011d1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1011d1:	6a 00                	push   $0x0
  pushl $89
  1011d3:	6a 59                	push   $0x59
  jmp alltraps
  1011d5:	e9 a6 fb ff ff       	jmp    100d80 <alltraps>

001011da <vector90>:
.globl vector90
vector90:
  pushl $0
  1011da:	6a 00                	push   $0x0
  pushl $90
  1011dc:	6a 5a                	push   $0x5a
  jmp alltraps
  1011de:	e9 9d fb ff ff       	jmp    100d80 <alltraps>

001011e3 <vector91>:
.globl vector91
vector91:
  pushl $0
  1011e3:	6a 00                	push   $0x0
  pushl $91
  1011e5:	6a 5b                	push   $0x5b
  jmp alltraps
  1011e7:	e9 94 fb ff ff       	jmp    100d80 <alltraps>

001011ec <vector92>:
.globl vector92
vector92:
  pushl $0
  1011ec:	6a 00                	push   $0x0
  pushl $92
  1011ee:	6a 5c                	push   $0x5c
  jmp alltraps
  1011f0:	e9 8b fb ff ff       	jmp    100d80 <alltraps>

001011f5 <vector93>:
.globl vector93
vector93:
  pushl $0
  1011f5:	6a 00                	push   $0x0
  pushl $93
  1011f7:	6a 5d                	push   $0x5d
  jmp alltraps
  1011f9:	e9 82 fb ff ff       	jmp    100d80 <alltraps>

001011fe <vector94>:
.globl vector94
vector94:
  pushl $0
  1011fe:	6a 00                	push   $0x0
  pushl $94
  101200:	6a 5e                	push   $0x5e
  jmp alltraps
  101202:	e9 79 fb ff ff       	jmp    100d80 <alltraps>

00101207 <vector95>:
.globl vector95
vector95:
  pushl $0
  101207:	6a 00                	push   $0x0
  pushl $95
  101209:	6a 5f                	push   $0x5f
  jmp alltraps
  10120b:	e9 70 fb ff ff       	jmp    100d80 <alltraps>

00101210 <vector96>:
.globl vector96
vector96:
  pushl $0
  101210:	6a 00                	push   $0x0
  pushl $96
  101212:	6a 60                	push   $0x60
  jmp alltraps
  101214:	e9 67 fb ff ff       	jmp    100d80 <alltraps>

00101219 <vector97>:
.globl vector97
vector97:
  pushl $0
  101219:	6a 00                	push   $0x0
  pushl $97
  10121b:	6a 61                	push   $0x61
  jmp alltraps
  10121d:	e9 5e fb ff ff       	jmp    100d80 <alltraps>

00101222 <vector98>:
.globl vector98
vector98:
  pushl $0
  101222:	6a 00                	push   $0x0
  pushl $98
  101224:	6a 62                	push   $0x62
  jmp alltraps
  101226:	e9 55 fb ff ff       	jmp    100d80 <alltraps>

0010122b <vector99>:
.globl vector99
vector99:
  pushl $0
  10122b:	6a 00                	push   $0x0
  pushl $99
  10122d:	6a 63                	push   $0x63
  jmp alltraps
  10122f:	e9 4c fb ff ff       	jmp    100d80 <alltraps>

00101234 <vector100>:
.globl vector100
vector100:
  pushl $0
  101234:	6a 00                	push   $0x0
  pushl $100
  101236:	6a 64                	push   $0x64
  jmp alltraps
  101238:	e9 43 fb ff ff       	jmp    100d80 <alltraps>

0010123d <vector101>:
.globl vector101
vector101:
  pushl $0
  10123d:	6a 00                	push   $0x0
  pushl $101
  10123f:	6a 65                	push   $0x65
  jmp alltraps
  101241:	e9 3a fb ff ff       	jmp    100d80 <alltraps>

00101246 <vector102>:
.globl vector102
vector102:
  pushl $0
  101246:	6a 00                	push   $0x0
  pushl $102
  101248:	6a 66                	push   $0x66
  jmp alltraps
  10124a:	e9 31 fb ff ff       	jmp    100d80 <alltraps>

0010124f <vector103>:
.globl vector103
vector103:
  pushl $0
  10124f:	6a 00                	push   $0x0
  pushl $103
  101251:	6a 67                	push   $0x67
  jmp alltraps
  101253:	e9 28 fb ff ff       	jmp    100d80 <alltraps>

00101258 <vector104>:
.globl vector104
vector104:
  pushl $0
  101258:	6a 00                	push   $0x0
  pushl $104
  10125a:	6a 68                	push   $0x68
  jmp alltraps
  10125c:	e9 1f fb ff ff       	jmp    100d80 <alltraps>

00101261 <vector105>:
.globl vector105
vector105:
  pushl $0
  101261:	6a 00                	push   $0x0
  pushl $105
  101263:	6a 69                	push   $0x69
  jmp alltraps
  101265:	e9 16 fb ff ff       	jmp    100d80 <alltraps>

0010126a <vector106>:
.globl vector106
vector106:
  pushl $0
  10126a:	6a 00                	push   $0x0
  pushl $106
  10126c:	6a 6a                	push   $0x6a
  jmp alltraps
  10126e:	e9 0d fb ff ff       	jmp    100d80 <alltraps>

00101273 <vector107>:
.globl vector107
vector107:
  pushl $0
  101273:	6a 00                	push   $0x0
  pushl $107
  101275:	6a 6b                	push   $0x6b
  jmp alltraps
  101277:	e9 04 fb ff ff       	jmp    100d80 <alltraps>

0010127c <vector108>:
.globl vector108
vector108:
  pushl $0
  10127c:	6a 00                	push   $0x0
  pushl $108
  10127e:	6a 6c                	push   $0x6c
  jmp alltraps
  101280:	e9 fb fa ff ff       	jmp    100d80 <alltraps>

00101285 <vector109>:
.globl vector109
vector109:
  pushl $0
  101285:	6a 00                	push   $0x0
  pushl $109
  101287:	6a 6d                	push   $0x6d
  jmp alltraps
  101289:	e9 f2 fa ff ff       	jmp    100d80 <alltraps>

0010128e <vector110>:
.globl vector110
vector110:
  pushl $0
  10128e:	6a 00                	push   $0x0
  pushl $110
  101290:	6a 6e                	push   $0x6e
  jmp alltraps
  101292:	e9 e9 fa ff ff       	jmp    100d80 <alltraps>

00101297 <vector111>:
.globl vector111
vector111:
  pushl $0
  101297:	6a 00                	push   $0x0
  pushl $111
  101299:	6a 6f                	push   $0x6f
  jmp alltraps
  10129b:	e9 e0 fa ff ff       	jmp    100d80 <alltraps>

001012a0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1012a0:	6a 00                	push   $0x0
  pushl $112
  1012a2:	6a 70                	push   $0x70
  jmp alltraps
  1012a4:	e9 d7 fa ff ff       	jmp    100d80 <alltraps>

001012a9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1012a9:	6a 00                	push   $0x0
  pushl $113
  1012ab:	6a 71                	push   $0x71
  jmp alltraps
  1012ad:	e9 ce fa ff ff       	jmp    100d80 <alltraps>

001012b2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1012b2:	6a 00                	push   $0x0
  pushl $114
  1012b4:	6a 72                	push   $0x72
  jmp alltraps
  1012b6:	e9 c5 fa ff ff       	jmp    100d80 <alltraps>

001012bb <vector115>:
.globl vector115
vector115:
  pushl $0
  1012bb:	6a 00                	push   $0x0
  pushl $115
  1012bd:	6a 73                	push   $0x73
  jmp alltraps
  1012bf:	e9 bc fa ff ff       	jmp    100d80 <alltraps>

001012c4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1012c4:	6a 00                	push   $0x0
  pushl $116
  1012c6:	6a 74                	push   $0x74
  jmp alltraps
  1012c8:	e9 b3 fa ff ff       	jmp    100d80 <alltraps>

001012cd <vector117>:
.globl vector117
vector117:
  pushl $0
  1012cd:	6a 00                	push   $0x0
  pushl $117
  1012cf:	6a 75                	push   $0x75
  jmp alltraps
  1012d1:	e9 aa fa ff ff       	jmp    100d80 <alltraps>

001012d6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1012d6:	6a 00                	push   $0x0
  pushl $118
  1012d8:	6a 76                	push   $0x76
  jmp alltraps
  1012da:	e9 a1 fa ff ff       	jmp    100d80 <alltraps>

001012df <vector119>:
.globl vector119
vector119:
  pushl $0
  1012df:	6a 00                	push   $0x0
  pushl $119
  1012e1:	6a 77                	push   $0x77
  jmp alltraps
  1012e3:	e9 98 fa ff ff       	jmp    100d80 <alltraps>

001012e8 <vector120>:
.globl vector120
vector120:
  pushl $0
  1012e8:	6a 00                	push   $0x0
  pushl $120
  1012ea:	6a 78                	push   $0x78
  jmp alltraps
  1012ec:	e9 8f fa ff ff       	jmp    100d80 <alltraps>

001012f1 <vector121>:
.globl vector121
vector121:
  pushl $0
  1012f1:	6a 00                	push   $0x0
  pushl $121
  1012f3:	6a 79                	push   $0x79
  jmp alltraps
  1012f5:	e9 86 fa ff ff       	jmp    100d80 <alltraps>

001012fa <vector122>:
.globl vector122
vector122:
  pushl $0
  1012fa:	6a 00                	push   $0x0
  pushl $122
  1012fc:	6a 7a                	push   $0x7a
  jmp alltraps
  1012fe:	e9 7d fa ff ff       	jmp    100d80 <alltraps>

00101303 <vector123>:
.globl vector123
vector123:
  pushl $0
  101303:	6a 00                	push   $0x0
  pushl $123
  101305:	6a 7b                	push   $0x7b
  jmp alltraps
  101307:	e9 74 fa ff ff       	jmp    100d80 <alltraps>

0010130c <vector124>:
.globl vector124
vector124:
  pushl $0
  10130c:	6a 00                	push   $0x0
  pushl $124
  10130e:	6a 7c                	push   $0x7c
  jmp alltraps
  101310:	e9 6b fa ff ff       	jmp    100d80 <alltraps>

00101315 <vector125>:
.globl vector125
vector125:
  pushl $0
  101315:	6a 00                	push   $0x0
  pushl $125
  101317:	6a 7d                	push   $0x7d
  jmp alltraps
  101319:	e9 62 fa ff ff       	jmp    100d80 <alltraps>

0010131e <vector126>:
.globl vector126
vector126:
  pushl $0
  10131e:	6a 00                	push   $0x0
  pushl $126
  101320:	6a 7e                	push   $0x7e
  jmp alltraps
  101322:	e9 59 fa ff ff       	jmp    100d80 <alltraps>

00101327 <vector127>:
.globl vector127
vector127:
  pushl $0
  101327:	6a 00                	push   $0x0
  pushl $127
  101329:	6a 7f                	push   $0x7f
  jmp alltraps
  10132b:	e9 50 fa ff ff       	jmp    100d80 <alltraps>

00101330 <vector128>:
.globl vector128
vector128:
  pushl $0
  101330:	6a 00                	push   $0x0
  pushl $128
  101332:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101337:	e9 44 fa ff ff       	jmp    100d80 <alltraps>

0010133c <vector129>:
.globl vector129
vector129:
  pushl $0
  10133c:	6a 00                	push   $0x0
  pushl $129
  10133e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  101343:	e9 38 fa ff ff       	jmp    100d80 <alltraps>

00101348 <vector130>:
.globl vector130
vector130:
  pushl $0
  101348:	6a 00                	push   $0x0
  pushl $130
  10134a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  10134f:	e9 2c fa ff ff       	jmp    100d80 <alltraps>

00101354 <vector131>:
.globl vector131
vector131:
  pushl $0
  101354:	6a 00                	push   $0x0
  pushl $131
  101356:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  10135b:	e9 20 fa ff ff       	jmp    100d80 <alltraps>

00101360 <vector132>:
.globl vector132
vector132:
  pushl $0
  101360:	6a 00                	push   $0x0
  pushl $132
  101362:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  101367:	e9 14 fa ff ff       	jmp    100d80 <alltraps>

0010136c <vector133>:
.globl vector133
vector133:
  pushl $0
  10136c:	6a 00                	push   $0x0
  pushl $133
  10136e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  101373:	e9 08 fa ff ff       	jmp    100d80 <alltraps>

00101378 <vector134>:
.globl vector134
vector134:
  pushl $0
  101378:	6a 00                	push   $0x0
  pushl $134
  10137a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  10137f:	e9 fc f9 ff ff       	jmp    100d80 <alltraps>

00101384 <vector135>:
.globl vector135
vector135:
  pushl $0
  101384:	6a 00                	push   $0x0
  pushl $135
  101386:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  10138b:	e9 f0 f9 ff ff       	jmp    100d80 <alltraps>

00101390 <vector136>:
.globl vector136
vector136:
  pushl $0
  101390:	6a 00                	push   $0x0
  pushl $136
  101392:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  101397:	e9 e4 f9 ff ff       	jmp    100d80 <alltraps>

0010139c <vector137>:
.globl vector137
vector137:
  pushl $0
  10139c:	6a 00                	push   $0x0
  pushl $137
  10139e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  1013a3:	e9 d8 f9 ff ff       	jmp    100d80 <alltraps>

001013a8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1013a8:	6a 00                	push   $0x0
  pushl $138
  1013aa:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  1013af:	e9 cc f9 ff ff       	jmp    100d80 <alltraps>

001013b4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1013b4:	6a 00                	push   $0x0
  pushl $139
  1013b6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  1013bb:	e9 c0 f9 ff ff       	jmp    100d80 <alltraps>

001013c0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1013c0:	6a 00                	push   $0x0
  pushl $140
  1013c2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  1013c7:	e9 b4 f9 ff ff       	jmp    100d80 <alltraps>

001013cc <vector141>:
.globl vector141
vector141:
  pushl $0
  1013cc:	6a 00                	push   $0x0
  pushl $141
  1013ce:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  1013d3:	e9 a8 f9 ff ff       	jmp    100d80 <alltraps>

001013d8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1013d8:	6a 00                	push   $0x0
  pushl $142
  1013da:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  1013df:	e9 9c f9 ff ff       	jmp    100d80 <alltraps>

001013e4 <vector143>:
.globl vector143
vector143:
  pushl $0
  1013e4:	6a 00                	push   $0x0
  pushl $143
  1013e6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  1013eb:	e9 90 f9 ff ff       	jmp    100d80 <alltraps>

001013f0 <vector144>:
.globl vector144
vector144:
  pushl $0
  1013f0:	6a 00                	push   $0x0
  pushl $144
  1013f2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  1013f7:	e9 84 f9 ff ff       	jmp    100d80 <alltraps>

001013fc <vector145>:
.globl vector145
vector145:
  pushl $0
  1013fc:	6a 00                	push   $0x0
  pushl $145
  1013fe:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  101403:	e9 78 f9 ff ff       	jmp    100d80 <alltraps>

00101408 <vector146>:
.globl vector146
vector146:
  pushl $0
  101408:	6a 00                	push   $0x0
  pushl $146
  10140a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  10140f:	e9 6c f9 ff ff       	jmp    100d80 <alltraps>

00101414 <vector147>:
.globl vector147
vector147:
  pushl $0
  101414:	6a 00                	push   $0x0
  pushl $147
  101416:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  10141b:	e9 60 f9 ff ff       	jmp    100d80 <alltraps>

00101420 <vector148>:
.globl vector148
vector148:
  pushl $0
  101420:	6a 00                	push   $0x0
  pushl $148
  101422:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101427:	e9 54 f9 ff ff       	jmp    100d80 <alltraps>

0010142c <vector149>:
.globl vector149
vector149:
  pushl $0
  10142c:	6a 00                	push   $0x0
  pushl $149
  10142e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101433:	e9 48 f9 ff ff       	jmp    100d80 <alltraps>

00101438 <vector150>:
.globl vector150
vector150:
  pushl $0
  101438:	6a 00                	push   $0x0
  pushl $150
  10143a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  10143f:	e9 3c f9 ff ff       	jmp    100d80 <alltraps>

00101444 <vector151>:
.globl vector151
vector151:
  pushl $0
  101444:	6a 00                	push   $0x0
  pushl $151
  101446:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  10144b:	e9 30 f9 ff ff       	jmp    100d80 <alltraps>

00101450 <vector152>:
.globl vector152
vector152:
  pushl $0
  101450:	6a 00                	push   $0x0
  pushl $152
  101452:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  101457:	e9 24 f9 ff ff       	jmp    100d80 <alltraps>

0010145c <vector153>:
.globl vector153
vector153:
  pushl $0
  10145c:	6a 00                	push   $0x0
  pushl $153
  10145e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  101463:	e9 18 f9 ff ff       	jmp    100d80 <alltraps>

00101468 <vector154>:
.globl vector154
vector154:
  pushl $0
  101468:	6a 00                	push   $0x0
  pushl $154
  10146a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  10146f:	e9 0c f9 ff ff       	jmp    100d80 <alltraps>

00101474 <vector155>:
.globl vector155
vector155:
  pushl $0
  101474:	6a 00                	push   $0x0
  pushl $155
  101476:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  10147b:	e9 00 f9 ff ff       	jmp    100d80 <alltraps>

00101480 <vector156>:
.globl vector156
vector156:
  pushl $0
  101480:	6a 00                	push   $0x0
  pushl $156
  101482:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  101487:	e9 f4 f8 ff ff       	jmp    100d80 <alltraps>

0010148c <vector157>:
.globl vector157
vector157:
  pushl $0
  10148c:	6a 00                	push   $0x0
  pushl $157
  10148e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  101493:	e9 e8 f8 ff ff       	jmp    100d80 <alltraps>

00101498 <vector158>:
.globl vector158
vector158:
  pushl $0
  101498:	6a 00                	push   $0x0
  pushl $158
  10149a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  10149f:	e9 dc f8 ff ff       	jmp    100d80 <alltraps>

001014a4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1014a4:	6a 00                	push   $0x0
  pushl $159
  1014a6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  1014ab:	e9 d0 f8 ff ff       	jmp    100d80 <alltraps>

001014b0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1014b0:	6a 00                	push   $0x0
  pushl $160
  1014b2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  1014b7:	e9 c4 f8 ff ff       	jmp    100d80 <alltraps>

001014bc <vector161>:
.globl vector161
vector161:
  pushl $0
  1014bc:	6a 00                	push   $0x0
  pushl $161
  1014be:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  1014c3:	e9 b8 f8 ff ff       	jmp    100d80 <alltraps>

001014c8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1014c8:	6a 00                	push   $0x0
  pushl $162
  1014ca:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  1014cf:	e9 ac f8 ff ff       	jmp    100d80 <alltraps>

001014d4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1014d4:	6a 00                	push   $0x0
  pushl $163
  1014d6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  1014db:	e9 a0 f8 ff ff       	jmp    100d80 <alltraps>

001014e0 <vector164>:
.globl vector164
vector164:
  pushl $0
  1014e0:	6a 00                	push   $0x0
  pushl $164
  1014e2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  1014e7:	e9 94 f8 ff ff       	jmp    100d80 <alltraps>

001014ec <vector165>:
.globl vector165
vector165:
  pushl $0
  1014ec:	6a 00                	push   $0x0
  pushl $165
  1014ee:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  1014f3:	e9 88 f8 ff ff       	jmp    100d80 <alltraps>

001014f8 <vector166>:
.globl vector166
vector166:
  pushl $0
  1014f8:	6a 00                	push   $0x0
  pushl $166
  1014fa:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  1014ff:	e9 7c f8 ff ff       	jmp    100d80 <alltraps>

00101504 <vector167>:
.globl vector167
vector167:
  pushl $0
  101504:	6a 00                	push   $0x0
  pushl $167
  101506:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  10150b:	e9 70 f8 ff ff       	jmp    100d80 <alltraps>

00101510 <vector168>:
.globl vector168
vector168:
  pushl $0
  101510:	6a 00                	push   $0x0
  pushl $168
  101512:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101517:	e9 64 f8 ff ff       	jmp    100d80 <alltraps>

0010151c <vector169>:
.globl vector169
vector169:
  pushl $0
  10151c:	6a 00                	push   $0x0
  pushl $169
  10151e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101523:	e9 58 f8 ff ff       	jmp    100d80 <alltraps>

00101528 <vector170>:
.globl vector170
vector170:
  pushl $0
  101528:	6a 00                	push   $0x0
  pushl $170
  10152a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  10152f:	e9 4c f8 ff ff       	jmp    100d80 <alltraps>

00101534 <vector171>:
.globl vector171
vector171:
  pushl $0
  101534:	6a 00                	push   $0x0
  pushl $171
  101536:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  10153b:	e9 40 f8 ff ff       	jmp    100d80 <alltraps>

00101540 <vector172>:
.globl vector172
vector172:
  pushl $0
  101540:	6a 00                	push   $0x0
  pushl $172
  101542:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101547:	e9 34 f8 ff ff       	jmp    100d80 <alltraps>

0010154c <vector173>:
.globl vector173
vector173:
  pushl $0
  10154c:	6a 00                	push   $0x0
  pushl $173
  10154e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101553:	e9 28 f8 ff ff       	jmp    100d80 <alltraps>

00101558 <vector174>:
.globl vector174
vector174:
  pushl $0
  101558:	6a 00                	push   $0x0
  pushl $174
  10155a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  10155f:	e9 1c f8 ff ff       	jmp    100d80 <alltraps>

00101564 <vector175>:
.globl vector175
vector175:
  pushl $0
  101564:	6a 00                	push   $0x0
  pushl $175
  101566:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  10156b:	e9 10 f8 ff ff       	jmp    100d80 <alltraps>

00101570 <vector176>:
.globl vector176
vector176:
  pushl $0
  101570:	6a 00                	push   $0x0
  pushl $176
  101572:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  101577:	e9 04 f8 ff ff       	jmp    100d80 <alltraps>

0010157c <vector177>:
.globl vector177
vector177:
  pushl $0
  10157c:	6a 00                	push   $0x0
  pushl $177
  10157e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  101583:	e9 f8 f7 ff ff       	jmp    100d80 <alltraps>

00101588 <vector178>:
.globl vector178
vector178:
  pushl $0
  101588:	6a 00                	push   $0x0
  pushl $178
  10158a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  10158f:	e9 ec f7 ff ff       	jmp    100d80 <alltraps>

00101594 <vector179>:
.globl vector179
vector179:
  pushl $0
  101594:	6a 00                	push   $0x0
  pushl $179
  101596:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  10159b:	e9 e0 f7 ff ff       	jmp    100d80 <alltraps>

001015a0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1015a0:	6a 00                	push   $0x0
  pushl $180
  1015a2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  1015a7:	e9 d4 f7 ff ff       	jmp    100d80 <alltraps>

001015ac <vector181>:
.globl vector181
vector181:
  pushl $0
  1015ac:	6a 00                	push   $0x0
  pushl $181
  1015ae:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  1015b3:	e9 c8 f7 ff ff       	jmp    100d80 <alltraps>

001015b8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1015b8:	6a 00                	push   $0x0
  pushl $182
  1015ba:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  1015bf:	e9 bc f7 ff ff       	jmp    100d80 <alltraps>

001015c4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1015c4:	6a 00                	push   $0x0
  pushl $183
  1015c6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  1015cb:	e9 b0 f7 ff ff       	jmp    100d80 <alltraps>

001015d0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1015d0:	6a 00                	push   $0x0
  pushl $184
  1015d2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  1015d7:	e9 a4 f7 ff ff       	jmp    100d80 <alltraps>

001015dc <vector185>:
.globl vector185
vector185:
  pushl $0
  1015dc:	6a 00                	push   $0x0
  pushl $185
  1015de:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  1015e3:	e9 98 f7 ff ff       	jmp    100d80 <alltraps>

001015e8 <vector186>:
.globl vector186
vector186:
  pushl $0
  1015e8:	6a 00                	push   $0x0
  pushl $186
  1015ea:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  1015ef:	e9 8c f7 ff ff       	jmp    100d80 <alltraps>

001015f4 <vector187>:
.globl vector187
vector187:
  pushl $0
  1015f4:	6a 00                	push   $0x0
  pushl $187
  1015f6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  1015fb:	e9 80 f7 ff ff       	jmp    100d80 <alltraps>

00101600 <vector188>:
.globl vector188
vector188:
  pushl $0
  101600:	6a 00                	push   $0x0
  pushl $188
  101602:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101607:	e9 74 f7 ff ff       	jmp    100d80 <alltraps>

0010160c <vector189>:
.globl vector189
vector189:
  pushl $0
  10160c:	6a 00                	push   $0x0
  pushl $189
  10160e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101613:	e9 68 f7 ff ff       	jmp    100d80 <alltraps>

00101618 <vector190>:
.globl vector190
vector190:
  pushl $0
  101618:	6a 00                	push   $0x0
  pushl $190
  10161a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  10161f:	e9 5c f7 ff ff       	jmp    100d80 <alltraps>

00101624 <vector191>:
.globl vector191
vector191:
  pushl $0
  101624:	6a 00                	push   $0x0
  pushl $191
  101626:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  10162b:	e9 50 f7 ff ff       	jmp    100d80 <alltraps>

00101630 <vector192>:
.globl vector192
vector192:
  pushl $0
  101630:	6a 00                	push   $0x0
  pushl $192
  101632:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101637:	e9 44 f7 ff ff       	jmp    100d80 <alltraps>

0010163c <vector193>:
.globl vector193
vector193:
  pushl $0
  10163c:	6a 00                	push   $0x0
  pushl $193
  10163e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101643:	e9 38 f7 ff ff       	jmp    100d80 <alltraps>

00101648 <vector194>:
.globl vector194
vector194:
  pushl $0
  101648:	6a 00                	push   $0x0
  pushl $194
  10164a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  10164f:	e9 2c f7 ff ff       	jmp    100d80 <alltraps>

00101654 <vector195>:
.globl vector195
vector195:
  pushl $0
  101654:	6a 00                	push   $0x0
  pushl $195
  101656:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  10165b:	e9 20 f7 ff ff       	jmp    100d80 <alltraps>

00101660 <vector196>:
.globl vector196
vector196:
  pushl $0
  101660:	6a 00                	push   $0x0
  pushl $196
  101662:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  101667:	e9 14 f7 ff ff       	jmp    100d80 <alltraps>

0010166c <vector197>:
.globl vector197
vector197:
  pushl $0
  10166c:	6a 00                	push   $0x0
  pushl $197
  10166e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  101673:	e9 08 f7 ff ff       	jmp    100d80 <alltraps>

00101678 <vector198>:
.globl vector198
vector198:
  pushl $0
  101678:	6a 00                	push   $0x0
  pushl $198
  10167a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  10167f:	e9 fc f6 ff ff       	jmp    100d80 <alltraps>

00101684 <vector199>:
.globl vector199
vector199:
  pushl $0
  101684:	6a 00                	push   $0x0
  pushl $199
  101686:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  10168b:	e9 f0 f6 ff ff       	jmp    100d80 <alltraps>

00101690 <vector200>:
.globl vector200
vector200:
  pushl $0
  101690:	6a 00                	push   $0x0
  pushl $200
  101692:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  101697:	e9 e4 f6 ff ff       	jmp    100d80 <alltraps>

0010169c <vector201>:
.globl vector201
vector201:
  pushl $0
  10169c:	6a 00                	push   $0x0
  pushl $201
  10169e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  1016a3:	e9 d8 f6 ff ff       	jmp    100d80 <alltraps>

001016a8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1016a8:	6a 00                	push   $0x0
  pushl $202
  1016aa:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  1016af:	e9 cc f6 ff ff       	jmp    100d80 <alltraps>

001016b4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1016b4:	6a 00                	push   $0x0
  pushl $203
  1016b6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  1016bb:	e9 c0 f6 ff ff       	jmp    100d80 <alltraps>

001016c0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1016c0:	6a 00                	push   $0x0
  pushl $204
  1016c2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  1016c7:	e9 b4 f6 ff ff       	jmp    100d80 <alltraps>

001016cc <vector205>:
.globl vector205
vector205:
  pushl $0
  1016cc:	6a 00                	push   $0x0
  pushl $205
  1016ce:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  1016d3:	e9 a8 f6 ff ff       	jmp    100d80 <alltraps>

001016d8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1016d8:	6a 00                	push   $0x0
  pushl $206
  1016da:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  1016df:	e9 9c f6 ff ff       	jmp    100d80 <alltraps>

001016e4 <vector207>:
.globl vector207
vector207:
  pushl $0
  1016e4:	6a 00                	push   $0x0
  pushl $207
  1016e6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  1016eb:	e9 90 f6 ff ff       	jmp    100d80 <alltraps>

001016f0 <vector208>:
.globl vector208
vector208:
  pushl $0
  1016f0:	6a 00                	push   $0x0
  pushl $208
  1016f2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  1016f7:	e9 84 f6 ff ff       	jmp    100d80 <alltraps>

001016fc <vector209>:
.globl vector209
vector209:
  pushl $0
  1016fc:	6a 00                	push   $0x0
  pushl $209
  1016fe:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101703:	e9 78 f6 ff ff       	jmp    100d80 <alltraps>

00101708 <vector210>:
.globl vector210
vector210:
  pushl $0
  101708:	6a 00                	push   $0x0
  pushl $210
  10170a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  10170f:	e9 6c f6 ff ff       	jmp    100d80 <alltraps>

00101714 <vector211>:
.globl vector211
vector211:
  pushl $0
  101714:	6a 00                	push   $0x0
  pushl $211
  101716:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  10171b:	e9 60 f6 ff ff       	jmp    100d80 <alltraps>

00101720 <vector212>:
.globl vector212
vector212:
  pushl $0
  101720:	6a 00                	push   $0x0
  pushl $212
  101722:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101727:	e9 54 f6 ff ff       	jmp    100d80 <alltraps>

0010172c <vector213>:
.globl vector213
vector213:
  pushl $0
  10172c:	6a 00                	push   $0x0
  pushl $213
  10172e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101733:	e9 48 f6 ff ff       	jmp    100d80 <alltraps>

00101738 <vector214>:
.globl vector214
vector214:
  pushl $0
  101738:	6a 00                	push   $0x0
  pushl $214
  10173a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  10173f:	e9 3c f6 ff ff       	jmp    100d80 <alltraps>

00101744 <vector215>:
.globl vector215
vector215:
  pushl $0
  101744:	6a 00                	push   $0x0
  pushl $215
  101746:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  10174b:	e9 30 f6 ff ff       	jmp    100d80 <alltraps>

00101750 <vector216>:
.globl vector216
vector216:
  pushl $0
  101750:	6a 00                	push   $0x0
  pushl $216
  101752:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101757:	e9 24 f6 ff ff       	jmp    100d80 <alltraps>

0010175c <vector217>:
.globl vector217
vector217:
  pushl $0
  10175c:	6a 00                	push   $0x0
  pushl $217
  10175e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  101763:	e9 18 f6 ff ff       	jmp    100d80 <alltraps>

00101768 <vector218>:
.globl vector218
vector218:
  pushl $0
  101768:	6a 00                	push   $0x0
  pushl $218
  10176a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  10176f:	e9 0c f6 ff ff       	jmp    100d80 <alltraps>

00101774 <vector219>:
.globl vector219
vector219:
  pushl $0
  101774:	6a 00                	push   $0x0
  pushl $219
  101776:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  10177b:	e9 00 f6 ff ff       	jmp    100d80 <alltraps>

00101780 <vector220>:
.globl vector220
vector220:
  pushl $0
  101780:	6a 00                	push   $0x0
  pushl $220
  101782:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  101787:	e9 f4 f5 ff ff       	jmp    100d80 <alltraps>

0010178c <vector221>:
.globl vector221
vector221:
  pushl $0
  10178c:	6a 00                	push   $0x0
  pushl $221
  10178e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  101793:	e9 e8 f5 ff ff       	jmp    100d80 <alltraps>

00101798 <vector222>:
.globl vector222
vector222:
  pushl $0
  101798:	6a 00                	push   $0x0
  pushl $222
  10179a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  10179f:	e9 dc f5 ff ff       	jmp    100d80 <alltraps>

001017a4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1017a4:	6a 00                	push   $0x0
  pushl $223
  1017a6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  1017ab:	e9 d0 f5 ff ff       	jmp    100d80 <alltraps>

001017b0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1017b0:	6a 00                	push   $0x0
  pushl $224
  1017b2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  1017b7:	e9 c4 f5 ff ff       	jmp    100d80 <alltraps>

001017bc <vector225>:
.globl vector225
vector225:
  pushl $0
  1017bc:	6a 00                	push   $0x0
  pushl $225
  1017be:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  1017c3:	e9 b8 f5 ff ff       	jmp    100d80 <alltraps>

001017c8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1017c8:	6a 00                	push   $0x0
  pushl $226
  1017ca:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  1017cf:	e9 ac f5 ff ff       	jmp    100d80 <alltraps>

001017d4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1017d4:	6a 00                	push   $0x0
  pushl $227
  1017d6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  1017db:	e9 a0 f5 ff ff       	jmp    100d80 <alltraps>

001017e0 <vector228>:
.globl vector228
vector228:
  pushl $0
  1017e0:	6a 00                	push   $0x0
  pushl $228
  1017e2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  1017e7:	e9 94 f5 ff ff       	jmp    100d80 <alltraps>

001017ec <vector229>:
.globl vector229
vector229:
  pushl $0
  1017ec:	6a 00                	push   $0x0
  pushl $229
  1017ee:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  1017f3:	e9 88 f5 ff ff       	jmp    100d80 <alltraps>

001017f8 <vector230>:
.globl vector230
vector230:
  pushl $0
  1017f8:	6a 00                	push   $0x0
  pushl $230
  1017fa:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  1017ff:	e9 7c f5 ff ff       	jmp    100d80 <alltraps>

00101804 <vector231>:
.globl vector231
vector231:
  pushl $0
  101804:	6a 00                	push   $0x0
  pushl $231
  101806:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  10180b:	e9 70 f5 ff ff       	jmp    100d80 <alltraps>

00101810 <vector232>:
.globl vector232
vector232:
  pushl $0
  101810:	6a 00                	push   $0x0
  pushl $232
  101812:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101817:	e9 64 f5 ff ff       	jmp    100d80 <alltraps>

0010181c <vector233>:
.globl vector233
vector233:
  pushl $0
  10181c:	6a 00                	push   $0x0
  pushl $233
  10181e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101823:	e9 58 f5 ff ff       	jmp    100d80 <alltraps>

00101828 <vector234>:
.globl vector234
vector234:
  pushl $0
  101828:	6a 00                	push   $0x0
  pushl $234
  10182a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  10182f:	e9 4c f5 ff ff       	jmp    100d80 <alltraps>

00101834 <vector235>:
.globl vector235
vector235:
  pushl $0
  101834:	6a 00                	push   $0x0
  pushl $235
  101836:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  10183b:	e9 40 f5 ff ff       	jmp    100d80 <alltraps>

00101840 <vector236>:
.globl vector236
vector236:
  pushl $0
  101840:	6a 00                	push   $0x0
  pushl $236
  101842:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101847:	e9 34 f5 ff ff       	jmp    100d80 <alltraps>

0010184c <vector237>:
.globl vector237
vector237:
  pushl $0
  10184c:	6a 00                	push   $0x0
  pushl $237
  10184e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101853:	e9 28 f5 ff ff       	jmp    100d80 <alltraps>

00101858 <vector238>:
.globl vector238
vector238:
  pushl $0
  101858:	6a 00                	push   $0x0
  pushl $238
  10185a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  10185f:	e9 1c f5 ff ff       	jmp    100d80 <alltraps>

00101864 <vector239>:
.globl vector239
vector239:
  pushl $0
  101864:	6a 00                	push   $0x0
  pushl $239
  101866:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  10186b:	e9 10 f5 ff ff       	jmp    100d80 <alltraps>

00101870 <vector240>:
.globl vector240
vector240:
  pushl $0
  101870:	6a 00                	push   $0x0
  pushl $240
  101872:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  101877:	e9 04 f5 ff ff       	jmp    100d80 <alltraps>

0010187c <vector241>:
.globl vector241
vector241:
  pushl $0
  10187c:	6a 00                	push   $0x0
  pushl $241
  10187e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  101883:	e9 f8 f4 ff ff       	jmp    100d80 <alltraps>

00101888 <vector242>:
.globl vector242
vector242:
  pushl $0
  101888:	6a 00                	push   $0x0
  pushl $242
  10188a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  10188f:	e9 ec f4 ff ff       	jmp    100d80 <alltraps>

00101894 <vector243>:
.globl vector243
vector243:
  pushl $0
  101894:	6a 00                	push   $0x0
  pushl $243
  101896:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  10189b:	e9 e0 f4 ff ff       	jmp    100d80 <alltraps>

001018a0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1018a0:	6a 00                	push   $0x0
  pushl $244
  1018a2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  1018a7:	e9 d4 f4 ff ff       	jmp    100d80 <alltraps>

001018ac <vector245>:
.globl vector245
vector245:
  pushl $0
  1018ac:	6a 00                	push   $0x0
  pushl $245
  1018ae:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  1018b3:	e9 c8 f4 ff ff       	jmp    100d80 <alltraps>

001018b8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1018b8:	6a 00                	push   $0x0
  pushl $246
  1018ba:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  1018bf:	e9 bc f4 ff ff       	jmp    100d80 <alltraps>

001018c4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1018c4:	6a 00                	push   $0x0
  pushl $247
  1018c6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  1018cb:	e9 b0 f4 ff ff       	jmp    100d80 <alltraps>

001018d0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1018d0:	6a 00                	push   $0x0
  pushl $248
  1018d2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  1018d7:	e9 a4 f4 ff ff       	jmp    100d80 <alltraps>

001018dc <vector249>:
.globl vector249
vector249:
  pushl $0
  1018dc:	6a 00                	push   $0x0
  pushl $249
  1018de:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  1018e3:	e9 98 f4 ff ff       	jmp    100d80 <alltraps>

001018e8 <vector250>:
.globl vector250
vector250:
  pushl $0
  1018e8:	6a 00                	push   $0x0
  pushl $250
  1018ea:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  1018ef:	e9 8c f4 ff ff       	jmp    100d80 <alltraps>

001018f4 <vector251>:
.globl vector251
vector251:
  pushl $0
  1018f4:	6a 00                	push   $0x0
  pushl $251
  1018f6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  1018fb:	e9 80 f4 ff ff       	jmp    100d80 <alltraps>

00101900 <vector252>:
.globl vector252
vector252:
  pushl $0
  101900:	6a 00                	push   $0x0
  pushl $252
  101902:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101907:	e9 74 f4 ff ff       	jmp    100d80 <alltraps>

0010190c <vector253>:
.globl vector253
vector253:
  pushl $0
  10190c:	6a 00                	push   $0x0
  pushl $253
  10190e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101913:	e9 68 f4 ff ff       	jmp    100d80 <alltraps>

00101918 <vector254>:
.globl vector254
vector254:
  pushl $0
  101918:	6a 00                	push   $0x0
  pushl $254
  10191a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  10191f:	e9 5c f4 ff ff       	jmp    100d80 <alltraps>

00101924 <vector255>:
.globl vector255
vector255:
  pushl $0
  101924:	6a 00                	push   $0x0
  pushl $255
  101926:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10192b:	e9 50 f4 ff ff       	jmp    100d80 <alltraps>

00101930 <mousewait_send>:
    if (data & flag) {                  \
        cprintf(message);\
        cprintf("\n"); \
    }

void mousewait_send(void){
  101930:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101934:	ba 64 00 00 00       	mov    $0x64,%edx
  101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101940:	ec                   	in     (%dx),%al
    WHL((inb(MSSTATP) & 0x02) != 0 ,);
  101941:	a8 02                	test   $0x2,%al
  101943:	75 fb                	jne    101940 <mousewait_send+0x10>
}
  101945:	c3                   	ret    
  101946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10194d:	8d 76 00             	lea    0x0(%esi),%esi

00101950 <mousewait_recv>:


void mousewait_recv(void){
  101950:	f3 0f 1e fb          	endbr32 
  101954:	ba 64 00 00 00       	mov    $0x64,%edx
  101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101960:	ec                   	in     (%dx),%al
     WHL((inb(MSSTATP) & 0x01) == 0,);
  101961:	a8 01                	test   $0x1,%al
  101963:	74 fb                	je     101960 <mousewait_recv+0x10>
}
  101965:	c3                   	ret    
  101966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10196d:	8d 76 00             	lea    0x0(%esi),%esi

00101970 <mousecmd>:

void mousecmd(uchar cmd){
  101970:	f3 0f 1e fb          	endbr32 
  101974:	55                   	push   %ebp
  101975:	ba 64 00 00 00       	mov    $0x64,%edx
  10197a:	89 e5                	mov    %esp,%ebp
  10197c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10197f:	90                   	nop
  101980:	ec                   	in     (%dx),%al
    WHL((inb(MSSTATP) & 0x02) != 0 ,);
  101981:	a8 02                	test   $0x2,%al
  101983:	75 fb                	jne    101980 <mousecmd+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101985:	b8 d4 ff ff ff       	mov    $0xffffffd4,%eax
  10198a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10198b:	ba 64 00 00 00       	mov    $0x64,%edx
  101990:	ec                   	in     (%dx),%al
  101991:	a8 02                	test   $0x2,%al
  101993:	75 fb                	jne    101990 <mousecmd+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101995:	ba 60 00 00 00       	mov    $0x60,%edx
  10199a:	89 c8                	mov    %ecx,%eax
  10199c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10199d:	ba 64 00 00 00       	mov    $0x64,%edx
  1019a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1019a8:	ec                   	in     (%dx),%al
     WHL((inb(MSSTATP) & 0x01) == 0,);
  1019a9:	a8 01                	test   $0x1,%al
  1019ab:	74 fb                	je     1019a8 <mousecmd+0x38>
  1019ad:	ba 60 00 00 00       	mov    $0x60,%edx
  1019b2:	ec                   	in     (%dx),%al
    msend;
    outb(MSDATAP, cmd);  
    mrecv;
    
    uchar response = inb(MSDATAP); 
    if (response != MSACK) {
  1019b3:	3c fa                	cmp    $0xfa,%al
  1019b5:	75 09                	jne    1019c0 <mousecmd+0x50>
        cprintf("Mouse command failed\n");
        return;
    }
}
  1019b7:	5d                   	pop    %ebp
  1019b8:	c3                   	ret    
  1019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("Mouse command failed\n");
  1019c0:	c7 45 08 e8 1c 10 00 	movl   $0x101ce8,0x8(%ebp)
}
  1019c7:	5d                   	pop    %ebp
        cprintf("Mouse command failed\n");
  1019c8:	e9 23 e7 ff ff       	jmp    1000f0 <cprintf>
  1019cd:	8d 76 00             	lea    0x0(%esi),%esi

001019d0 <mouseinit>:


void mouseinit(void) {
  1019d0:	f3 0f 1e fb          	endbr32 
  1019d4:	55                   	push   %ebp
  1019d5:	89 e5                	mov    %esp,%ebp
  1019d7:	83 ec 14             	sub    $0x14,%esp
    
    cprintf("Mouse has been initialized\n");
  1019da:	68 fe 1c 10 00       	push   $0x101cfe
  1019df:	e8 0c e7 ff ff       	call   1000f0 <cprintf>
    WHL((inb(MSSTATP) & 0x02) != 0 ,);
  1019e4:	83 c4 10             	add    $0x10,%esp
  1019e7:	ba 64 00 00 00       	mov    $0x64,%edx
  1019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1019f0:	ec                   	in     (%dx),%al
  1019f1:	a8 02                	test   $0x2,%al
  1019f3:	75 fb                	jne    1019f0 <mouseinit+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019f5:	b8 a8 ff ff ff       	mov    $0xffffffa8,%eax
  1019fa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019fb:	ba 64 00 00 00       	mov    $0x64,%edx
  101a00:	ec                   	in     (%dx),%al
  101a01:	a8 02                	test   $0x2,%al
  101a03:	75 fb                	jne    101a00 <mouseinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a05:	b8 20 00 00 00       	mov    $0x20,%eax
  101a0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a0b:	ba 64 00 00 00       	mov    $0x64,%edx
  101a10:	ec                   	in     (%dx),%al
     WHL((inb(MSSTATP) & 0x01) == 0,);
  101a11:	a8 01                	test   $0x1,%al
  101a13:	74 fb                	je     101a10 <mouseinit+0x40>
  101a15:	ba 60 00 00 00       	mov    $0x60,%edx
  101a1a:	ec                   	in     (%dx),%al
    
    msend;
    outb(MSSTATP, 0x20);  

    mrecv;
    uchar status = (inb(MSDATAP) | 0x02); 
  101a1b:	83 c8 02             	or     $0x2,%eax
  101a1e:	ba 64 00 00 00       	mov    $0x64,%edx
  101a23:	89 c1                	mov    %eax,%ecx
void mousewait_send(void){
  101a25:	8d 76 00             	lea    0x0(%esi),%esi
  101a28:	ec                   	in     (%dx),%al
    WHL((inb(MSSTATP) & 0x02) != 0 ,);
  101a29:	a8 02                	test   $0x2,%al
  101a2b:	75 fb                	jne    101a28 <mouseinit+0x58>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a2d:	b8 60 00 00 00       	mov    $0x60,%eax
  101a32:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a33:	ba 64 00 00 00       	mov    $0x64,%edx
  101a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a3f:	90                   	nop
  101a40:	ec                   	in     (%dx),%al
  101a41:	a8 02                	test   $0x2,%al
  101a43:	75 fb                	jne    101a40 <mouseinit+0x70>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a45:	ba 60 00 00 00       	mov    $0x60,%edx
  101a4a:	89 c8                	mov    %ecx,%eax
  101a4c:	ee                   	out    %al,(%dx)
    outb(MSSTATP, 0x60);  

    msend;
    outb(MSDATAP, status);  

    mousecmd(0xF6);
  101a4d:	83 ec 0c             	sub    $0xc,%esp
  101a50:	68 f6 00 00 00       	push   $0xf6
  101a55:	e8 16 ff ff ff       	call   101970 <mousecmd>
    mousecmd(0xF4);
  101a5a:	c7 04 24 f4 00 00 00 	movl   $0xf4,(%esp)
  101a61:	e8 0a ff ff ff       	call   101970 <mousecmd>
    ioapicenable(IRQ_MOUSE, 0);
  101a66:	58                   	pop    %eax
  101a67:	5a                   	pop    %edx
  101a68:	6a 00                	push   $0x0
  101a6a:	6a 0c                	push   $0xc
  101a6c:	e8 8f ea ff ff       	call   100500 <ioapicenable>
}
  101a71:	83 c4 10             	add    $0x10,%esp
  101a74:	c9                   	leave  
  101a75:	c3                   	ret    
  101a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a7d:	8d 76 00             	lea    0x0(%esi),%esi

00101a80 <mouseintr>:


void mouseintr(void) {
  101a80:	f3 0f 1e fb          	endbr32 
  101a84:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a85:	ba 64 00 00 00       	mov    $0x64,%edx
  101a8a:	89 e5                	mov    %esp,%ebp
  101a8c:	53                   	push   %ebx
  101a8d:	83 ec 04             	sub    $0x4,%esp
  101a90:	ec                   	in     (%dx),%al
     WHL((inb(MSSTATP) & 0x01) == 0,);
  101a91:	a8 01                	test   $0x1,%al
  101a93:	74 fb                	je     101a90 <mouseintr+0x10>
  101a95:	ba 60 00 00 00       	mov    $0x60,%edx
  101a9a:	ec                   	in     (%dx),%al
  101a9b:	89 c3                	mov    %eax,%ebx
    mrecv;
    uchar data;
    data = inb(MSDATAP); 

    CHECK_AND_PRINT(0x01, "LEFT");
  101a9d:	a8 01                	test   $0x1,%al
  101a9f:	75 0f                	jne    101ab0 <mouseintr+0x30>
    CHECK_AND_PRINT(0x02, "RIGHT");
  101aa1:	f6 c3 02             	test   $0x2,%bl
  101aa4:	75 2b                	jne    101ad1 <mouseintr+0x51>
    CHECK_AND_PRINT(0x04, "MID");
  101aa6:	83 e3 04             	and    $0x4,%ebx
  101aa9:	75 47                	jne    101af2 <mouseintr+0x72>
}
  101aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101aae:	c9                   	leave  
  101aaf:	c3                   	ret    
    CHECK_AND_PRINT(0x01, "LEFT");
  101ab0:	83 ec 0c             	sub    $0xc,%esp
  101ab3:	68 1a 1d 10 00       	push   $0x101d1a
  101ab8:	e8 33 e6 ff ff       	call   1000f0 <cprintf>
  101abd:	c7 04 24 d1 1b 10 00 	movl   $0x101bd1,(%esp)
  101ac4:	e8 27 e6 ff ff       	call   1000f0 <cprintf>
  101ac9:	83 c4 10             	add    $0x10,%esp
    CHECK_AND_PRINT(0x02, "RIGHT");
  101acc:	f6 c3 02             	test   $0x2,%bl
  101acf:	74 d5                	je     101aa6 <mouseintr+0x26>
  101ad1:	83 ec 0c             	sub    $0xc,%esp
  101ad4:	68 1f 1d 10 00       	push   $0x101d1f
  101ad9:	e8 12 e6 ff ff       	call   1000f0 <cprintf>
  101ade:	c7 04 24 d1 1b 10 00 	movl   $0x101bd1,(%esp)
  101ae5:	e8 06 e6 ff ff       	call   1000f0 <cprintf>
  101aea:	83 c4 10             	add    $0x10,%esp
    CHECK_AND_PRINT(0x04, "MID");
  101aed:	83 e3 04             	and    $0x4,%ebx
  101af0:	74 b9                	je     101aab <mouseintr+0x2b>
  101af2:	83 ec 0c             	sub    $0xc,%esp
  101af5:	68 25 1d 10 00       	push   $0x101d25
  101afa:	e8 f1 e5 ff ff       	call   1000f0 <cprintf>
  101aff:	c7 04 24 d1 1b 10 00 	movl   $0x101bd1,(%esp)
  101b06:	e8 e5 e5 ff ff       	call   1000f0 <cprintf>
}
  101b0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    CHECK_AND_PRINT(0x04, "MID");
  101b0e:	83 c4 10             	add    $0x10,%esp
}
  101b11:	c9                   	leave  
  101b12:	c3                   	ret    

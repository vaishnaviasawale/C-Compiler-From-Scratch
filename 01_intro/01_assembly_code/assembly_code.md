# CPU and Memory

(Page 11 from book)

Both the program executed by the CPU and the data that the program reads and writes are
stored in memory. The CPU maintains an internal record of the address of the currently
executing instruction. It reads the instruction from that address, performs the actions written in
it, and then reads and executes the next instruction. This address of the currently executing
instruction is called the " program counter " (PC) or " instruction pointer " (IP). The format of the
program that the CPU executes is called " machine code ."

The program counter doesn't always progress linearly to the next instruction. Using a type of
instruction called a "branch instruction" in the CPU, you can set the program counter to any
address other than the next instruction. This feature enables if statements and loops. Setting
the program counter to a location other than the next instruction is called "jumping" or
"branching".

Memory is an external device from the CPU's perspective, and reading
and writing to it takes some time, but registers reside inside the CPU and can be accessed
without delay. They are 16 areas that can hold 64-bit integers (x86-64).

Many machine codes follow a format where they perform some operation using the values ​of
two registers and write the result back to the registers. Therefore, program execution proceeds
as the CPU reads data from memory into registers, performs some operation between the
registers, and writes the result back to memory.

A set of machine language instructions is collectively called an " instruction set architecture "
(ISA) or simply an "instruction set."


# Assembler

(Page 13 from book):

Assembly language has an almost one-to-one correspondence with machine code, but it is far
easier for humans to read than machine code.


# Packages

gcc is used to compile C programs.
g++ is the GNU compiler driver normally used for C++.
make is a build automation tool.
objdump is a binary inspection tool. It can take the executable binary and show you information about what's inside it, including its machine instructions.


# Code 

## test1.c
Compile using 'cc -o test1 test1.c' or 'gcc -o test1 test1.c'.
This produces test1.c  →  test1 where test1 is the executable.
We run ./test1 and see NOTHING! Our program doesn't print anything, it simply returns 42.
Immediately run 'echo $?' to get '42'
$? is a special shell variable containing the exit status of the most recently executed command.

To look at the assembly generated from your C: gcc -S -masm=intel -O0 test1.c -o test1.s
This tells GCC:
-S → stop after generating assembly; don't assemble/link
-masm=intel → use Intel syntax (like the book)
-O0 → don't optimize
-o test1.s → write assembly to test1.s

cat test1.s shows:
	.file	"test1.c"
	.intel_syntax noprefix
	.text
	.globl	"main"
	.type	"main", @function
"main":
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, 42
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	"main", .-"main"
	.ident	"GCC: (GNU) 16.2.1 20260819 (Red Hat 16.2.1-2)"
	.section	.note.GNU-stack,"",@progbits


The 'mov eax, 42' and 'ret' is GCC translating 'return 42;' into instructions that ultimately put 42 into the return-value register and return from main.

## test2.s
Run 'gcc -o test2 test2.s' and then './test2'. Again, nothing happens till you eun 'echo $?' to get '42'

## test1.c vs test2.s
             C
             │
             │ gcc
             ▼
        test1 executable
             │
             ▼
          exit 42


          Assembly
             │
             │ gcc
             ▼
        test2 executable
             │
             ▼
          exit 42


For test2.s, we gave GCC an assembly source file, and GCC arranged for it to be assembled and linked into an executable.

Basically,
test2.s
   │
   │ assembler (as)
   ▼
test2.o
   │
   │ linker (ld)
   ▼
test2
   │
   ▼
executable


Technically:
C → assembly = compilation
assembly → object code = assembly
object code → executable = linking

## ojdump
We take our executable: 'objdump -d -M intel test1' and get a lot of output in the format:
test1:     file format elf64-x86-64


Disassembly of section .init:

000000000040033c <_init>:
  40033c:	f3 0f 1e fa          	endbr64
  400340:	48 83 ec 08          	sub    rsp,0x8
  400344:	48 8b 05 95 2c 00 00 	mov    rax,QWORD PTR [rip+0x2c95]        # 402fe0 <__gmon_start__>
  40034b:	48 85 c0             	test   rax,rax
  40034e:	74 02                	je     400352 <_init+0x16>
  400350:	ff d0                	call   rax
  400352:	48 83 c4 08          	add    rsp,0x8
  400356:	c3                   	ret

Disassembly of section .text:

0000000000400360 <_start>:
  400360:	f3 0f 1e fa          	endbr64
  400364:	31 ed                	xor    ebp,ebp
  400366:	49 89 d1             	mov    r9,rdx
  400369:	5e                   	pop    rsi
  40036a:	48 89 e2             	mov    rdx,rsp
  40036d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
  400371:	50                   	push   rax
  400372:	54                   	push   rsp
  400373:	45 31 c0             	xor    r8d,r8d
  400376:	31 c9                	xor    ecx,ecx
  400378:	48 c7 c7 46 04 40 00 	mov    rdi,0x400446
  40037f:	ff 15 53 2c 00 00    	call   QWORD PTR [rip+0x2c53]        # 402fd8 <__libc_start_main@GLIBC_2.34>
  400385:	f4                   	hlt
  400386:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  40038d:	00 00 00 

etc

To focus on main: objdump -d -M intel test1 | grep -A20 '<main>'

0000000000400446 <main>:
  400446:	55                   	push   rbp
  400447:	48 89 e5             	mov    rbp,rsp
  40044a:	b8 2a 00 00 00       	mov    eax,0x2a
  40044f:	5d                   	pop    rbp
  400450:	c3                   	ret

Disassembly of section .fini:

0000000000400454 <_fini>:
  400454:	f3 0f 1e fa          	endbr64
  400458:	48 83 ec 08          	sub    rsp,0x8
  40045c:	48 83 c4 08          	add    rsp,0x8
  400460:	c3                   	ret

Here we see, 0x2a is hexadecimal for 42 (can be verified by running 'printf '%d\n' $((16#2a))'.

'mov eax, 0x2a' is represented by machine-code bytes.
objdump shows both:
machine code          assembly
─────────────         ─────────
b8 2a 00 00 00        mov eax,0x2a
c3                    ret

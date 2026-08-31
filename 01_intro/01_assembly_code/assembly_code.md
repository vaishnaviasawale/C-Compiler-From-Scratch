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
In this assembly, a global label mainis defined, followed by the mainfunction code. Here, the
value 42 is set to the register RAX, and mainthen the function returns. There are a total of 16
registers that can hold integers, including RAX, but the value in RAX when the function returns
is considered the function's return value, so the value is set to RAX here.

In x86 and x86-64 architecture, the RAX register stores the primary return value when a function finishes executing.

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


# Function Calls

Unlike a simple jump, a function call requires the program to return to its original execution
location after the called function finishes. This original execution address is called the "return
address." If there is only one function call, the return address can be stored in a suitable
register in the CPU. However, since function calls can be made infinitely deep, the return
address is stored on the memory
stack . A stack can be implemented using only one variable that holds the address of the top of the
stack. The memory area that holds the address of the top of the stack is called the "stack
pointer." x86-64 supports a dedicated register for the stack pointer and instructions that use
that register to support function-based programming.


# Code

## test3.c

Running './test3' gives nothing, but running 'echo $?' shows 7

## test4.s

The first line specifies the assembly syntax. .globlThe line starting with the second line
instructs assembly that the two functions and are visible to the entire program, not just within
the file scope.

In assembly
language, the convention is that the first argument goes into the RDI register and the second
argument goes into the RSI register, so the main first two lines of the code set the values ​
accordingly.

The syntax is: add destination, source
We could write 'add rsi, rdi' or 'add rdi, rsi' because addition is commutative.

call plus does the following:
- Push the address of the next instruction (in this case ret) onto the stack
- Jump to the address given as an argument

Therefore, once the instruction call is executed, the CPU will begin executing the function plus.

The result of adding the RSI register and the
RDI register is written to the RSI register. Since x86-64 integer arithmetic instructions usually
only accept two registers, the result is saved by overwriting the value of the first argument
register.

The function's return value was supposed to be stored in RAX. Therefore, we want the result of
the addition to be stored in RAX, so we need to copy the value from RSI to RAX. Here, we
movare doing this using a command. mov is an abbreviation for move, but in reality, it's a
command that simply copies the data, not moves it.

At the end of the function plus, it calls a method to return from the function. Specifically,
ret does the following:
- Pop one address from the stack.
- Jump to that address

Basically ret command undoes what was done and resumes execution of the calling
function. It is defined as a command that is paired with call. 

Here, the return value of plus is stored
in RAX, so by returning directly, it can be made to be the return value of main.

## test3.s vs test4.s

rdi and edi are different-sized views of the same physical register:
64-bit register:   RDI
                     │
                     └── lower 32 bits: EDI

Likewise:
RSI
 │
 └── lower 32 bits: ESI

RAX
 │
 └── lower 32 bits: EAX

Our C function uses int a, int b, int plus()

An int on your x86-64 Linux system is 32 bits, so GCC uses edi, esi, and eax

Our sample test4.s uses rdi, rsi, and rax to keep the example simple.

Also, instead of just:
plus:
    add rsi, rdi
    mov rax, rsi
    ret

GCC gives:
push rbp
mov rbp, rsp

mov DWORD PTR [rbp-4], edi
mov DWORD PTR [rbp-8], esi

...

GCC is creating a stack frame for plus:
             stack
               ↓
       ┌─────────────────┐
       │ saved RBP       │
       ├─────────────────┤
       │ a               │
       ├─────────────────┤
       │ b               │
       └─────────────────┘

It's taking the incoming arguments: 
EDI = a
ESI = b

and storing them in memory:
[rbp-4] = a
[rbp-8] = b

RBP (Register Base Pointer) is a CPU register. A common use for RBP is to act as a reference point for a function's stack frame. 
             stack
               ↓

        ┌─────────────────┐
        │                 │
        │ function stuff  │
        │                 │
        └─────────────────┘
               ↑
              RBP
The stack is simply a region of your program's memory that functions commonly use for temporary storage. RSP = Stack Pointer points roughly to the top of the stack.

RBP can be used as a stable reference point within the current function's stack frame.
higher memory
       │
       │
       ▼
┌──────────────────┐
│ caller's stuff   │
├──────────────────┤
│ return address   │
├──────────────────┤ ← RBP
│ local variable   │ ← [rbp-4]
├──────────────────┤
│ local variable   │ ← [rbp-8]
└──────────────────┘
       ↑
      RSP
       │
lower memory

mov DWORD PTR [rbp-4], edi
means:
memory address = RBP - 4
store the value of EDI there

where [rbp-4] is basically "the memory location 4 bytes below RBP" and [rbp-8] is "the memory location 8 bytes below RBP"

             RBP
              ↓
        ┌──────────────┐
        │              │
        ├──────────────┤
        │      a       │ ← [rbp-4]
        ├──────────────┤
        │      b       │ ← [rbp-8]
        └──────────────┘

Our C function has two int parameters and an int is 4 bytes. So GCC can give them 4-byte slots. Then when GCC does 'mov DWORD PTR [rbp-4], edi' meaning a = EDI.

Theoretically GCC could just do:
             RBP
              ↓
        ┌──────────────┐
        │              │
        ├──────────────┤
        │      a       │ ← [rbp-4]
        ├──────────────┤
        │      b       │ ← [rbp-8]
        └──────────────┘

But you compiled without optimization (-O0), so GCC wants a conventional stack representation for the variables.

It essentially does:
EDI ──────→ [RBP-4]   (a)
ESI ──────→ [RBP-8]   (b)

Then later:
mov edx, DWORD PTR [rbp-4]
mov eax, DWORD PTR [rbp-8]
add eax, edx

Then, we have:
push rbp
mov rbp, rsp

When push rbp is executed, the CPU puts the old RBP value onto the stack. 

Conceptually:
Before:

RBP → old frame
RSP → top of stack


After push rbp:

        ┌──────────────┐
        │ old RBP      │ ← RSP
        └──────────────┘

Then, mov rbp, rsp, turns it into:
Now:
RBP
 ↓
┌──────────────┐
│ old RBP      │
└──────────────┘
↑
RSP

So RBP becomes a stable reference point for this function's stack frame.

Then GCC can say:
[rbp-4]
[rbp-8]
and know exactly where its local data is.

At the end:
pop rbp
ret

pop rbp restores the old RBP that was saved by push rbp and ret handles the return address that was put on the stack by call.

test3_2.s provides us with an optimized version, but since it is compiled using -02, GCC looked at your whole program, not just each line independently, and realized what the final result would be.

lea eax, [rdi+rsi]
lea means Load Effective Address and it calculates that expression without actually accessing memory. Because of an optimisation called "constant folding", 3+4 was evaluated at compile time, so GCC replaces the whole calculation with:
mov eax, 7
ret

Constant folding is a compiler optimization technique that evaluates constant expressions at compile time instead of waiting for runtime.
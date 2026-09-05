Expressions like 5 + 20 - 4 can be calculated at compile time and the resulting number (21) embedded in the assembly, but that would make it behave more like an interpreter than a compiler, so it's necessary to output assembly that performs addition and subtraction at runtime. 

add and subtract write the result to the first register

Our compilers job is to take a simple expression such as: 5+20-4 and convert it into **x86-64 assembly code**.

The generated assembly can then be assembled and linked into an executable.

### Program 1 — Our compiler

The compiler is the C program we are writing.

For example:

```c
int main(int argc, char **argv) {
    ...
}
```

It receives an expression such as:

```
5+20-4
```

and prints assembly code.

### Program 2 — The generated program

Our compiler produces assembly such as:

```asm
main:
    mov rax, 5
    add rax, 20
    sub rax, 4
    ret
```

That assembly is then turned into another executable.

So:

```
Our compiler
     │
     │ generates
     ▼
Assembly program
     │
     │ assembled + linked
     ▼
Final executable
```

These are separate programs.

---

# 3. The compiler's exit status vs. the generated program's result

There are also two different meanings of `return`.

## Our compiler

If our compiler does:

```c
return 0;
```

that means:

> The compiler finished successfully.

If it does:

```c
return 1;
```

that means:

> The compiler encountered an error.

For example:

```c
fprintf(stderr, "Unexpected character: '%c'\n", *p);
return 1;
```

means the compiler detected invalid input and exited with an error status.

We can check this using:

```bash
echo $?
```

---

## The generated program

The generated assembly might contain:

```asm
mov rax, 5
add rax, 20
sub rax, 4
ret
```

Here `RAX` contains:

```
21
```

when `ret` is reached.

Because `main` returns an `int`, the value in `RAX` is used as the program's return value.

Therefore:

```bash
./program
echo $?
```

can print:

```
21
```

Compiler's return value
    → tells us whether compilation succeeded

Generated program's return value
    → is the result of the expression

---

# 4. Why does the compiler generate instructions instead of calculating the answer itself?

Suppose our compiler receives:

```
5+20-4
```

It could simply calculate:

```
5 + 20 - 4 = 21
```

and generate:

```asm
mov rax, 21
ret
```

Instead, our compiler generates:

```asm
mov rax, 5
add rax, 20
sub rax, 4
ret
```

This means the **generated program itself performs the calculation when it runs**.

The compiler is translating the operations into machine instructions.

Conceptually:

```
5 + 20 - 4
     │
     ▼
mov rax, 5
add rax, 20
sub rax, 4
```

The calculation happens at **runtime**.

Later, a real compiler may optimize constant expressions.

For example:

```c
int main() {
    return 5 + 20 - 4;
}
```

could be optimized into something equivalent to:

```asm
mov eax, 21
ret
```

This optimization is called **constant folding**.

---

# 5. Understanding `strtol`

```c
strtol()
```

to read numbers from the input string.

This is useful because we don't just need the number.

We also need to know **where the number ended**.

For example, suppose the input is:

```
123+456
```

Initially:

```
p
│
▼
123+456
```

The pointer `p` points to the first character:

```
'1'
```

When we call:

```c
strtol(p, &p, 10)
```

it reads:

```
123
```

and updates `p`.

After the call:

```
123+456
   ▲
   p
```

Now `p` points to:

```
'+'
```

So `strtol()` gives us two useful things:

1. The number that was parsed.
2. The location where parsing stopped.

IMPORTANT: strtol() already moves p for us.

strtol(p, &p, 10)
strtol() reads the number and because we passed &p as the second argument, it also changes p to point immediately after the number it just read.

---

# 6. What does this line mean?

```c
char *p = argv[1];
```

`argv[1]` contains the expression provided on the command line.

For example:

```bash
./compiler "123+456"
```

Then:

```
argv[1]
   │
   ▼
"123+456"
```

The pointer:

```c
char *p
```

is made to point at the beginning of that string.

So initially:

```
p
│
▼
1 2 3 + 4 5 6 \0
```

---

# 7. Why not use `atoi()`?

We could use:

```c
atoi()
```

to convert a string into an integer.

For example:

```c
atoi("123")
```

returns:

```
123
```

But `atoi()` doesn't conveniently tell us where the number ended.

With:

```
123+456
```

we need to know that after reading `123`, the next character is:

```
+
```

`strtol()` gives us this ability.

That makes it much more useful for parsing expressions.

---

# 8. Understanding the parsing loop

The compiler contains logic similar to:

```c
while (*p) {
    if (*p == '+') {
        p++;
        printf("add rax, %ld\n", strtol(p, &p, 10));
        continue;
    }

    if (*p == '-') {
        p++;
        printf("sub rax, %ld\n", strtol(p, &p, 10));
        continue;
    }

    fprintf(stderr, "Unexpected character: '%c'\n", *p);
    return 1;
}
```

This is essentially the compiler's first parser.


---

# 9. What does `*p` mean?

If:

```c
char *p;
```

then:

```c
p
```

is the address of a character.

And:

```c
*p
```

means:

> The character stored at the address `p`.

For example:

```
p
│
▼
5 + 20 - 4
```

Then:

```c
*p
```

is:

```
'5'
```

If `p` moves to the `+`:

```
5 + 20 - 4
  ▲
  p
```

then:

```c
*p
```

is:

```
'+'
```

---

# 10. What does `while (*p)` mean?

The input string ends with a special character called the **null character**:

```
'\0'
```

For example:

```
5 + 2 \0
```

So:

```c
while (*p)
```

means approximately:

> Keep processing characters until we reach `'\0'`.

When:

```c
*p == '\0'
```

the loop stops.

---

# 11. Parsing `5+20-4`

Let's trace the compiler.

Input:

```
5+20-4
```

Initially:

```
p
│
▼
5+20-4
```

The first number is parsed:

```c
strtol(p, &p, 10)
```

This reads:

```
5
```

and moves `p`:

```
5+20-4
 ▲
 p
```

Actually, after parsing `5`, `p` points at:

```
+
```

So the compiler generates:

```asm
mov rax, 5
```

---

## Next character: `+`

The compiler sees:

```c
if (*p == '+')
```

This is true.

Then:

```c
p++;
```

moves past the `+`.

Now:

```
5+20-4
  ▲
  p
```

`p` points to:

```
2
```

Then:

```c
strtol(p, &p, 10)
```

reads:

```
20
```

and moves `p` to the `-`.

The compiler generates:

```asm
add rax, 20
```

---

## Next character: `-`

The compiler sees:

```c
if (*p == '-')
```

This is true.

Then:

```c
p++;
```

moves past the `-`.

Now `p` points to:

```
4
```

The compiler calls:

```c
strtol(p, &p, 10)
```

which reads:

```
4
```

and moves `p` to the end of the string.

The compiler generates:

```asm
sub rax, 4
```

---

## End of input

Now:

```
p
│
▼
\0
```

Therefore:

```c
while (*p)
```

ends.

The compiler prints:

```asm
ret
```

The final generated assembly is:

```asm
.intel_syntax noprefix
.globl main

main:
    mov rax, 5
    add rax, 20
    sub rax, 4
    ret
```

IMPORTANT: the while loop starts over after every continue. continue means: Stop executing the rest of this iteration and jump back to the top of the while loop.

---

# 12. The grammar of the expressions we support

At this stage, the compiler supports a very simple grammar.

Conceptually:

```
number (("+" | "-") number)*
```

This means:

```
number
```

followed by zero or more:

```
operator + number
```

or:

```
operator - number
```

Examples that fit this grammar:

```
5
5+20
5-3
5+20-4
10-2+7-1
```

But expressions such as:

```
5*3
```

are not supported yet.

Neither are:

```
5/2
```

or:

```
(5+3)
```

---

# 13. This is already parsing

Even though the compiler is extremely small, it is already doing some fundamental compiler tasks.

It is:

1. Reading input.
2. Identifying numbers.
3. Identifying operators.
4. Keeping track of where it is in the input.
5. Generating assembly instructions.

This is an early form of:

```
Lexical analysis
       +
Parsing
       +
Code generation
```

# Run the code
gcc -o code1 code1.c
./code1 "5+20+4" > test1.s
gcc -o test1 test1.s
./test1
echo $?

"5+20-4" -> 245
"5+20+4" -> 29
"5+HELLO"-> 
>> ./code1 "5+HELLO" > test3.s
Unexpected character: 'H'
>> ./test3
Segmentation fault         (core dumped) ./test3
>> echo $?
139

1) Why 245
Linux process exit codes are unsigned 8-bit values 0-255
Our program returned -11, the low 8 bits of -11 are: 256-11 = 245
So, -11 becomes 245

2) 5+HELLO
After the first number:
5+HELLO
 ↑
 p

Then, p++ at '+' and p then points to H.

Then we call strtol(p, &p, 10), but there is no number starting at H

So strtol() cannot parse a number. It returns 0 and p does not advance because it couldn't parse anything. Therefore the compiler prints add rax, 0. And now p is still pointing at H, then the continue takes you back to while (*p) . Now *p == 'H' which isn't '+' or '-' where it prints the "Unexpected character" message 

# Segmentation fault
test3.s has valid assemblt, but it is not a valid complete program because it doesn't have a way for main to return (not ret statement). Since the CPU doesn't know that it should return from main, it simply continues executing whatever bytes happen to come after those instructions in the executable's code section. Eventually it tries to execute something invalid or accesses something it shouldn't, and the operating system kills the process:
Segmentation fault (core dumped)

"If my compiler did return 1, shouldn't test3.s somehow know that?"
No, These are two completely separate processes.

code1
 │
 ├── writes assembly to stdout
 │
 ├── detects H
 │
 ├── prints error to stderr
 │
 └── return 1

The shell then simply has test3.s. containing whatever was printed before the compiler exited. The return 1 does not magically get written into the assembly file.


# Why 139?
When a program crashes because of a signal, Linux shells commonly report: 128 + signal_number
A segmentation fault is signal 11, called SIGSEGV. So 128 + 11 = 139

# stdout vs stderr
stdout  ──────> test3.s

stderr  ──────> terminal
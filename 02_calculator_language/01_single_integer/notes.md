# Code

## code1.c and code1_2.s

gcc -o code1 code1.c
/code1 123 > code1_2.s

The first line compiles code1.c into the code code1 to create an executable file.

The second line passes the input 123 to code1 to generate the assembly code, which is the code1_2.s written to a file.

Then do:
gcc -o code1_2 code1_2.s
./code1_2
echo $?
Output: 123
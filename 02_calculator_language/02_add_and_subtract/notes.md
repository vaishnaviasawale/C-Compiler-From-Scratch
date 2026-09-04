Expressions like 5 + 20 - 4 can be calculated at compile time and the resulting number (21) embedded in the assembly, but that would make it behave more like an interpreter than a compiler, so it's necessary to output assembly that performs addition and subtraction at runtime. 

add and subtract write the result to the first register

# Questions
1 what is the last print statement
why do we retutn 1 inside the while loop
atoiHowever, it doesn't return the number of characters read, so we wouldn't know where to
start reading the next term. Therefore, we used a function atoifrom the C standard library
here .strtol
strtolThe function reads a number and then updates the pointer in the second argument to
point to the character following the last character read. Therefore, after reading a number, if
the next character is 'y' +, -then pthe function should point to that character. The program
above utilizes this fact whileto read terms one after another in a loop, outputting one line of
assembly code each time a term is read.

Add test:
It looks like the assembly is being output correctly. To test this new feature, test.shlet's add
the following line of test:
assert 21 "5+20-4"
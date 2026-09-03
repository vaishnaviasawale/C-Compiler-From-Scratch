Currently, every time you change your compiler, you have to manually do something like:

gcc -o code1 code1.c
./test1.sh

So let's create a file that tells make "Here are the commands I want you to run for me."

code1: code1.c
I want to create code1, and code1 depends on code1.c.

The CFLAGS line tells make what compiler flags to use when compiling C.

test: code1
	./test1.sh
This creates a target called test. To perform the test target, first make sure code1 exists and is up-to-date, then run ./test1.sh.

clean:
	rm -f code1 *.o *~ tmp*
This creates a target called clean. It executes the command which removes generated/temporary files.

.PHONY: test clean
test and clean are commands, not actual files, useful because you don't want make getting confused if you happen to have a file called test or clean.

# To run

- make
to build your compiler.

- make test
to:
1. Build code1 if necessary
2. Run your test script

- make clean
to clean up generated files.

# Outputs
>>  make
make: 'code1' is up to date.

>> make test
./test1.sh
0 => 0
42 => 42
OK

>> make clean
rm -f code1 *.o *~ tmp*


# Why use make?

The reason make became significant is that it solves a particular problem better than a simple script does: managing dependencies and deciding what actually needs to be rebuilt. We could have just written a simple bash/ python script for the same, but make handles dependencies. E.g. code1: code1.c reads as code1 depends on code1.c. make looks at the timestamps of these files, and if the source is newer than the executable, it rebuilds it. A normal script wouldn't automatically do this.

When we type "make" the shell tries to find an executable called make

By default, make looks for a file named Makefile (also makefile is commonly recognized) in the current working directory.

But you can tell make to use a different filename:
make -f MyBuildInstructions

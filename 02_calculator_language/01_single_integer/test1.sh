#!/bin/bash

assert() {
    expected="$1"
    input="$2"

    ./code1 "$input" > code1.s
    cc -o tmp code1.s
    ./tmp
    actual="$?"

    if [ "$actual" = "$expected" ]; 
    then echo "$input => $actual"
    else
        echo "$input => expected $expected, but got $actual"
        exit 1
    fi
}

assert 0 0
assert 42 42
assert 41 41

echo OK
#!/bin/bash

VAR2="Lie"
read VAR1 < current.txt
foo=$(git ls-remote https://github.com/blyatkid/hello-world-java.git HEAD)
foo=$(echo $foo | cut -d' ' -f1)

if [ "$foo" = "$VAR1" ]; then
    echo "Strings are equal."
else
    echo "Strings are not equal."
    echo $foo > current.txt
fi

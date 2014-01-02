#!/bin/bash
bison -d beard.y -v
yacc -d beard.y &&
lex beard.l &&
g++ lex.yy.c y.tab.c -w -o beard -lfl &&
mv beard bin/beard &&
rm lex.yy.c &&
rm y.tab.c &&
cd bin/ &&
./beard < source.bs

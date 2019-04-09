bison -d bison_file.y
flex flex_file.l
gcc lex.yy.c bison_file.tab.c -o op1
./op1
flex symbol.l
gcc lex.yy.c -o op2
./op2
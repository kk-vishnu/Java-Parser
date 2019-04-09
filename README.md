# Java-Parser
Noob java parser

6th semester CD project


To see complete execution, run the script file

$ ./script.sh



To see step-wise execution :

1) To run and parse the file :

$ bison -d bison_file.y

$ flex flex_file.y

$ gcc lex.yy.c bison_file.tab.c -o op

$ ./op


2) To generate symbol table :

$ flex symbol.l

$ gcc lex.yy.c -o op

$ ./op

NOTE: The Symbol Table will be stored in the file "sym_out.txt"



PS: You must have bison and flex installed. Runs on Ubuntu. 
PPS: Not a perfect parser(Errors like : Parse error if constructor has a modifier)

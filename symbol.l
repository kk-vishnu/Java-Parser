%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symbol.h"

	int checkKeyword(char buf[]){
		char *keys[] = {"abstract" , "assert" , "boolean" , "break" , "byte" , "case" , "catch" , 
		"char" , "class" ,	"const" , "continue" , "default" , "do" , "double" , "else" , "enum" , "extends" , 
		"final" , "finally" , "float" , "for" , "goto" , "if" , "implements" , "import" , "instanceof" , "int" ,	
		"interface" , "long" , "native" , "new" , "package" , "private" , "protected" , "public" , "return" ,
		"short" , "static" , "strictfp" , "super" , "switch" , "synchronized" , "this" , "threadsafe" , "throw" ,
		"throws" , "transient" , "try" , "void" , "volatile" ,	"while" , "scolon" , "dot" , "lc" , "rc" , "lp" ,
		"rp" , "lsb" , "rsb" , "colon" , "quesmark" , "comma" , "add" , "sub" , "mul" , "div" , "mod" , "assign" , 
		"addassign" , "subassign" , "mulassign" , "divassign" , "modassign" , "increment" , "decrement" , "exp" , 
		"dq" , "lt" , "lte" , "gt" , "gte" , "eqeq" , "nteq" , "true" , "false" , "num" , "not" , "band" , "bor" , 
		"bandeq" , "boreq" , "bxor" , "bxoreq" , "land" , "lor" , "tilde" , "signed_rshift" , "unsigned_rshift" , 
		"signed_lshift" , "float_type_suffix" , "hexnum" , "identifier" , "literal" , "String" , "redundant" ,
		 "doc_comment","out","println","System"};

		for(int i=0;i<108;i++){
			if((strcmp(buf, keys[i]) == 0 ))
				return 1;
		}

		return 0;
	}

	char global_type[256], global_scope = 'G';
	int is_func = 0, size,c=0;
	int argc = 0, argVals[105];
	char buf[256], func_name[256], func_retType[256], scope;

%}
%%
"import".*"\n" {
	//printf("\nMultiline comment.. Ignored\n");
}

"/*"(.|"\n")*"*/" {
	//printf("\nMultiline comment.. Ignored\n");
}

"//".*"\n" {
	//printf("\nSingle Line comment.... Ignored\n");
}

"\""(.)*"\"" {
	//printf("\nString Literal.... Ignored\n");	
}

"{" {
	c++;
	if(c!=0)
		global_scope = 'L';
	
	else
		global_scope = 'R';
}

"}" { c--;
	if(c!=0)
		global_scope = 'L';
	
	else
		global_scope = 'R';
	

}

")" {
	if(is_func == 1){
		insertToken(func_name, "FUNC", 0, scope, argc, argVals, func_retType);
		for(int i=0;i<50;i++){
			argVals[i] = 0;
		}
		argc = 0;
		is_func = 0;
	}
}

[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]* {

	int j = checkKeyword(yytext);
	if(j == 0){
		//printf("\n\n\nGTYPE = %s|%s\n\n\n", global_type, yytext);
		if(strcmp(global_type, "int") == 0 || strcmp(global_type, "float") == 0){
			size = 4;
		}
		else if(strcmp(global_type, "char") == 0){
			size = 1;
		}
		else if(strcmp(global_type, "double") == 0){
			size = 8;
		}
		if(is_func == 1){
			//global_scope = 'L';	
			argVals[argc] = compHash(yytext);
			argc++;
		}
		insertToken(yytext, global_type, size, global_scope, 0, NULL, " ");
	}
	else{
		strcpy(global_type, yytext);
	}
}

[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*("["[0-9]+"]") {
	//printf("\nIntel Inside..%s\n", yytext);
	int i=0;
	char buf[256];
	while(yytext[i] != '['){
		buf[i] = yytext[i];
		i++;
	}
	buf[i] = '\0';
	i++;
	int num = 0;
	while(yytext[i]!=']'){
		num = num*10 + ((int)yytext[i]-48);
		i++;
	}
	
	if(strcmp(global_type, "int") == 0 || strcmp(global_type, "float") == 0){
		size = 4;
	}
	else if(strcmp(global_type, "char") == 0){
		size = 1;
	}
	else if(strcmp(global_type, "double") == 0){
		size = 8;
	}

	if(is_func == 1){
		//global_scope = 'L';
		argVals[argc] = compHash(buf);
		argc++;
	}
	insertToken(buf, global_type, size*num, global_scope, 0, NULL, " ");
}

[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*"(" {
	int i=0;
	while(yytext[i] != '('){
		buf[i] = yytext[i];
		i++;
	}
	buf[i] = '\0';
	int j = checkKeyword(buf);
	if(j == 0){
		strcpy(func_name, buf);
		is_func = 1;
		//printf("FUNC\n");
		strcpy(func_retType, global_type);
		scope = global_scope;
		argc = 0;
	}
}

(.|"\n") {}

%%

int yywrap(){
	return 1;
}

int main(){
	initialize_symtable();
	yyin = fopen("inpfile.java", "r");
	yylex();

	displaySymTab();
}
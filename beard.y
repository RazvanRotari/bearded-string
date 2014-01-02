%{
#include <stdio.h>
#include <string>
extern int yylineno;
extern FILE* yyin;
extern char* yytext;
char * something;
void yyerror(const char *);
int yylex(void);
%}
%start s
%token<s> STR
%token<i> NR

%union {
    std::string *s;
    int i;
}
%left '+'
%left '*'

%%
s   : STR  { printf("AICI!!!%s \n",$1);}
    ;
%%
void yyerror(const char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(){
 yyparse();
}

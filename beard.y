%{
#include <stdio.h>
#include <string>
#include <iostream>
extern int yylineno;
extern FILE* yyin;
extern char* yytext;
char * something;
void yyerror(const char *);
int yylex(void);
std::string* min12(std::string *s1, std::string *s2);
%}
%start start
%token<s> STR
%token<i> NR
%token END
%type<s> operatie

%union {
    std::string *s;
    int i;
}

%left '+' '-'
%left '*'

%%
start   : linii
        ;

linii   : linie
        | linii linie
        ;

linie   : operatie END {std::cout << (*$1) << std::endl; }
        ;

operatie: operatie '+' operatie {$$ = new std::string((*$1) + (*$3)); delete $1; delete $3;}
        | operatie '-' operatie {$$ = min12($1, $3);}
        | STR
        ;
%%
std::string* min12(std::string *s1, std::string *s2)
{
    int pos ;
    while ((pos = s1->find (*s2)) != std::string::npos)
    {
        s1->erase(pos  , s2->length());
    }
    return s1;
}

void yyerror(const char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}


int main(){
 yyparse();
}

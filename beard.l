%{
#include <stdio.h>
#include <string>
#include "y.tab.h"
%}
%%
[A-Za-z]+ {yylval.s = new std::string(yytext); return STR;}
[0-9]+ {yylval.i = atoi(yytext); return NR;}
"==" {return ISEQUAL_OP;}
[ \t] ;
\n {yylineno++;return END;}
. {return yytext[0];}

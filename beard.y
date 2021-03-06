%{
#include <stdio.h>
#include <string>
#include <iostream>
#include <sstream>
extern int yylineno;
extern FILE* yyin;
extern char* yytext;
void yyerror(const char *);
int yylex(void);
std::string* min12(std::string *s1, std::string *s2);
std::string* mult(std::string *s1, int count);
std::string* mycount (std::string *s1, std::string *s2);
std::string* last_of (std::string *s1, int a_number);
std::string* last_of (std::string *s1, std::string *numbr);
std::string* first_of (std::string *s1, int a_number);
std::string* first_of (std::string *s1, std::string *numbr);
std::string* mylength (std::string *mystring);
std::string* is_equal (std::string *s1, std::string *s2);
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
%nonassoc '|' ISEQUAL_OP
%left '+' '-'
%left '*' '\'' '#' '?'

%%
start   : linii
        ;

linii   : linie
        | linii linie
        ;

linie   : operatie END {std::cout << (*$1) << std::endl; }
        ;

operatie: operatie '+' operatie {$$ = new std::string((*$1) + (*$3)); delete $1; delete $3;}
	| '(' operatie ')' {$$ = $2;}
	| '|' operatie '|' {$$ = mylength($2);}
	| operatie ISEQUAL_OP operatie {$$ = is_equal($1,$3);}
        | operatie '-' operatie {$$ = min12($1, $3);}
        | operatie '*' NR {$$ = mult($1, $3);}
        | operatie '?' operatie {$$ = mycount($1, $3);}
        | operatie '#' operatie {$$ = last_of ($1, $3);}
        | operatie '#' NR {$$ = last_of($1, $3);}
        | operatie '\'' operatie {$$ = first_of ($3, $1);}
        | NR '\'' operatie {$$ = first_of($3, $1);}
	| STR
        ;
%%
std::string* is_equal (std::string *s1, std::string *s2)
{
    if (s1->compare(*s2) == 0)
    {
	return new std::string ("1");
    }

    else
    {
	return new std::string ("0");
    }
}

std::string* mylength (std::string *mystring)
{
    std::ostringstream stream;
    stream << mystring->length();
    return new std::string(stream.str());
}

std::string* first_of (std::string *s1, int a_number)
{
    std::string *result = new std::string;
    if (a_number > s1->length() )
    {
        return s1;
    }

    if (a_number <= 0)
    {
        return new std::string("");
    }

    for (int i = 0 ; i<a_number ; i++)
    {
        result->push_back(s1->operator[](i));
    }

    return result;
}

std::string* first_of (std::string *s1, std::string *numbr)
{
    std::string::const_iterator it = numbr->begin();
    
    //std::cout << "Debug for \'\n";
    //std::cout << "Original string is " << *numbr << std::endl;
    while (it != numbr->end() )
    {
	//std::cout << *it;
	if (!std::isdigit (*it))
	{
		yyerror("Nu este numar la \'");
		return new std::string("");
	}
	++it;
    }

    return first_of (s1,atoi(numbr->c_str())); 
}

std::string* last_of (std::string *s1, int a_number)
{
    std::string *result = new std::string;
    if (a_number > s1->length() )
    {
        return s1;
    }

    if (a_number <= 0)
    {
        return new std::string("");
    }

    for (int i = (a_number-1) ; i>=0 ; i--)
    {
        result->push_back(s1->operator[](s1->length() -1 -i));
    }

    return result;
}

std::string* last_of (std::string *s1, std::string *numbr)
{
    //sorry, I do not like the function find_not_first_of :\
    //std::string numere("0123456789");
    //if((s1->find_not_first_of(numere, 0)) == std::string::npos)
    //{
    //    return last_of(s1, number);
    //}
    

    std::string::const_iterator it = numbr->begin();
    while (it != numbr->end() )
    {
	if (!std::isdigit (*it))
	{
		yyerror("Nu este numar la #");
		return new std::string("");
	}
	++it;
    }
    return last_of (s1,atoi(numbr->c_str()));    
}

std::string* mycount (std::string *s1, std::string *s2)
{
    int position = 0, mr = 0;
    while ( (position = s1->find(*s2,position)) !=std::string::npos)
    {
        mr++;
        position++;
    }
    std::ostringstream s;
    s << mr;
    return new std::string(s.str());
}

std::string* mult(std::string *s1, int count)
{
    std::string *result = new std::string(*s1);
    for (int i=0; i<count-1; i++)
    {
        (*result) += (*s1);
    }
    return result;
}

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

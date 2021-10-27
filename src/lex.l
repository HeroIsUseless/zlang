%{
  int chars = 0;
  int words = 0;
  int lines = 0;
  #include "parse.tab.h"
%}

%%
[a-zA-Z]+ {words++; chars+=strlen(yytext);}
"+" {printf("PLUS\n");}
"-" {printf("MINUS\n");}
"*" {printf("TIMES\n");}
"/" {printf("DIVIDE\n");}
"|" {printf("ABS\n");}
[0-9]+ {printf("NUMBER %s\n", yytext);}
\n {chars++; lines++;}
[\s\t] {}
. {}
%%

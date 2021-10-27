%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    void yyerror(char *s);
    extern int yylex();
    extern FILE* yyin;
    extern int yylineno;
%}
%union {
    int i;
    char* s;
    char c;
    double f;
}
%left '+' '-'
%left '*' '/'
%token <i> NUMBER
%token <i> INTEGER
%token ADD SUB MUL DIV ABS
%token <s> VAR
%token EOL
%type <i> exp factor term
%%
stmts: /* empty */ {}
     | stmt {printf("line %d\n", yylineno);} stmts
     ;

stmt: stmt_def
    ;

stmt_def: def_var
        ;

def_var: VAR ':' INTEGER ';'
       ;

calclist:
        | calclist exp EOL {printf(" = %d\n", $2);}
        ;

exp: factor 
   | exp ADD factor {$$ = $1 + $3;}
   | exp SUB factor {$$ = $1 - $3;}
   ;

factor: term 
      | factor MUL term {$$ = $1 * $3;}
      | factor DIV term {$$ = $1 / $3;}
      | '(' exp ')' {$$ = $2;}
      ;

term: NUMBER 
    | ABS term {$$ = $2 >= 0? $2 : - $2;}
    ;
%%

int main(int argc, char **argv){
    if(argc > 1){
        if(!(yyin = fopen(argv[1], "r"))){
            yyin = stdin;
        }
    }
    yylineno = 1;
    yyparse();
}

void yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}

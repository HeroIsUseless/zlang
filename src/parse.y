/*yacc最高支持LALR(1)文法，记住bison只能向前查看一个符号*/
/*yacc文件由3段组成，用2个%%行把这3段隔开*/

/*序言部分，定义 actions 中的C代码要用到的类型和变量，定义宏，用 #include 包含头文件等等。
要在此处声明词法分析器 yylex 和错误输出器 yyerror 。*/	
%{
#include <stdio.h>
#include <stdlib.h>
/*yacc用lex识别出一个记号后，放到变量yylval中，默认情况下yylval是int类型，也就是只能传递整型数据。*/
/*yylval是用YYSTYPE宏定义的，yylval就是宏YYSTYPE，只要重定义YYSTYPE宏，就能重新指定yylval的类型。*/
/*这里把YYSTYPE重定义为union Type，可存放多种信息*/ 
#define YYSTYPE Type
union Type{
	char String[20];
	int Int;
	char Char;
};
/*一个声明，必须要有，这表明，当解析器得到 lexer 返回的token时，
它可以认为全局变量 yylval 的名为 value 的成员已经在lex中被赋与了有意义的值。
用它就不用define YYSTYPE了*/
%union {
    int intval;
    double floatval;
    char *strval;
    int subtok;
}
void yyerror(const char *s); // 它会在编译的时候使用，调试用
extern int yylex(void);//该函数是在lex.yy.c里定义的，yyparse()里要调用该函数获取token
int sym[26];
%}
/*越先定义优先级越低 */
/*在表达式中如果有几个优先级相同的操作符，结合性就起仲裁的作用，由它决定哪个操作符先执行。*/
//%left       声明左结合操作符
//%right      声明右结合操作符
/* token 声明终结符，同等优先级的操作符可以分成一组进行声明 */
//%token      声明无结合性的语素类型
/* type 声明非终结符 */
%token    INTEGER VARIABLE
%left    '+' '-'
%left    '*' '/'
%token <strval> VAR
%token INT
%token WHILE
//单字符语素虽然不用声明，直接用字符即可，但声明它们可以指出其结合性，防止冲突

/* 至于匿名规则出现冲突，你只能选择滞后，而很多情况下，这是有效的，例如把括号向前移动一下 */
/* 到头了，却是一个空产生式，你是对其进行规约呢？还是继续移进呢？*/
/*很明显，它能无限规约，为什么有些中间的空产生式可以运行呢？实际上它刚好插在生成的符号表的末尾了*/
/*而不是我们规则的末尾，意味着根据下一个符号跳转到不同的表，而不是继续移进，它暗示着空产生式只规约一次*/
/*解决办法：很多情况下，加一个记忆区就足够了，必须要用，用$0就可以实现 */
/* 首先，规则表中只有终结符，其次，规则表在终结符不同的地方分裂，非终结符是会被拆分的，*/
/*那么对于空的非终结符而言，它下一个一定是不同的非终结符，这样你就知道，它是规约还是移进，*/
/*抑或是规约成那个空的非终结符，空非终结符一定是由下一个符号指定的 */

/*if可谓是最经典的易懂的移进规约冲突，它是规约成if呢？还是继续读else移进呢？*/
/*表示有else的话，就选择移进，而不是规约*/
%nonassoc ELSE
// %start指定文法的开始符号(非终结符)，既然是LALR文法，指定开始符号就是必要的，默认是第一个规则
%start program
%%
    /*语法规则部分*/
    /* 没有任何显式动作，将使用默认动作$$=$1 */
program:
    program statement '\n'
    |
    ;
statement:
     expr    {printf("%d\n", $1);}
     |VARIABLE '=' expr    {sym[$1] = $3;}
     ;
expr:
    INTEGER
    |VARIABLE{$$ = sym[$1];}
    |expr '+' expr    {$$ = $1 + $3;}
    |expr '-' expr    {$$ = $1 - $3;}
    |expr '*' expr    {$$ = $1 * $3;}
    |expr '/' expr    {$$ = $1 / $3;}
    |'('expr')'    {$$ = $2;}
    ;
%%

void yyerror(char* s)
{
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    printf("A simple calculator.\n");
    yyparse();
    return 0;
}

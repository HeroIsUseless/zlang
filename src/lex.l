/*lex工作原理*/
/*lex将规则部份的正规表达式转换成与之相应的DFA*/
/*并产生一个名为 int yylex() 的词法分析函数，将之拷贝到输出文件 lex.yy.c 中。*/ 
/*yylex函数通过对yyin的调用来获取要工作的文本。自动移动文件指针。*/
/*匹配模式的文本存储在yytext一变量中，是char*类型。*/
/*我们往往将yytext拷贝到yylval，给parse使用*/

/*lex文件由3段组成，用2个%%行把这3段隔开，与bison相同。*/
/*yywrap()	在文件（或输入）的末尾调用(在读到 EOF 时)。 如果函数的返回值是1，就停止解析。*/
/*作用是用来解析多个文件。但目前我们只有一个文件，因此我们总会禁用它*/
%option noyywrap 
/*第一部分，定义部分，定义段(definitions section)*/
/*定义段都被原样拷贝到最后生成的C代码文件中（当然%{和%}会被移走）*/
/*在书写时%{和%}都必须在一行的开始处，不能缩进。*/
%{
// 需要包含这个文件，这里定义着各种常量，因此先编译bison，把bison连接到flex，再编译flex
#include "y.tab.h"
#include <stdio.h>
// 这里说明一下自带的全局变量与函数：
// yyin	  FILE* 类型。 它指向 lexer 正在解析的当前文件。
// yyout	FILE* 类型。 它指向记录 lexer 输出的位置。 缺省情况下，yyin 和 yyout 都指向标准输入和输出。
// yytext	匹配模式的文本存储在这一变量中，是char*类型。
// yyleng	就是当前单词长度。
// yylineno	提供当前的行数信息。 （lexer不一定支持。）
// yylex()	开始分析字符串。 它由 Lex 自动生成。
// yylval 是parser里的，往往将yytext拷贝到yylval使用
extern char* yylval;
%}

/*第二部分，规则部分，规则段(rules section)*/
/*在规则段中，任何一行有缩进的文本都被原样拷贝到最后生成的C代码文件中。*/
%%
  /*匹配长度不同时，匹配最长的*/
  /*当两个表达式匹配同一个符号时，前面的表达式优先*/
  /*若无模式可匹配输入串，则使用缺省规则，将输入串原样拷贝至输出文件 yyout 中。*/
  /*因此关键字的表达式必须放到变量的表达式之前*/
[ \t]		              ;
"Int" return INT;
"String" return STRING;
"Float" return FLOAT;
[1-9]+[0-9]* return INT;
0\.[0-9]+ return FLOAT;
[1-9]+\.[0-9]+ return FLOAT;
\".*\" return STRING;
"if" return IF;
"while" return WHILE;
[a-zA-Z][a-zA-Z0-9]* return VAR;
"=" return EQ;
"\\<" return LE;
">/" return GE;
"<=" return ASGN;
"#" return NE;
">" return GT;
"<" return LT;
%%
/*第三部分，自定义代码部分*/
/*在其中定义的方法，函数，都应在第一部分声明*/
/*代码段可有可无，如果没有，第二个%%是可以省的*/
/*LEX 对此部份不作任何处理，仅仅将之直接拷贝到输出文件 lex.yy.c 的尾部。*/
/*本lex的生成文件是lex.yy.c*/

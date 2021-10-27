# 编译方式
default:
	cd build && bison -d ../src/parse.y 
	cd build && flex ../src/lex.l
	cd build && cc lex.yy.c parse.tab.c -ll
	cd build && ./a.out

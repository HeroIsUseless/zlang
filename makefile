# 编译方式
default:
	flex src/lex.l
	cc lex.yy.c -ll
	./a.out
	
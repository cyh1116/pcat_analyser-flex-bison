GCC = @g++
LEX = @flex
YACC = @bison

tree: tree.cpp yacc.o
			$(GCC) tree.cpp yacc.o -o tree

yacc.o: yacc.c
			$(GCC) -c yacc.c -w

yacc.c: parser.y lexer.c
			$(YACC) -o yacc.c -d parser.y

lexer.c: parser.l
			$(LEX) -o lexer.c parser.l

clean:
				@-rm -f *.o *~ yacc.c yacc.h lexer.c tree
.PHONY: clean

test:
			./tree tests/case_1.pcat  output/result1.txt
			./tree tests/case_2.pcat  output/result2.txt
			./tree tests/case_3.pcat  output/result3.txt
			./tree tests/case_4.pcat  output/result4.txt
			./tree tests/case_5.pcat  output/result5.txt
			./tree tests/case_6.pcat  output/result6.txt
			./tree tests/case_7.pcat  output/result7.txt
			./tree tests/case_8.pcat  output/result8.txt
			./tree tests/case_9.pcat  output/result9.txt
			./tree tests/case_10.pcat  output/result10.txt
			./tree tests/case_11.pcat  output/result11.txt -lex
			./tree tests/case_12.pcat  output/result12.txt
			./tree tests/case_13.pcat  output/result13.txt
			./tree tests/case_14.pcat  output/result14.txt
			
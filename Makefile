parser : scanner.l parser.y
	bison -yd -o parser.cpp parser.y
	flex -o lexer.cpp scanner.l
	g++ -o pascaler parser.cpp lexer.cpp

clean:
	rm -rf parser.cpp parser.hpp lexer.cpp pascaler
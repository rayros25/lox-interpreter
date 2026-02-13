# I feel like I should write something here.

CXX      = clang++
CXXFLAGS = -Wall -Wextra -Wreturn-type -g
LDFLAGS  = -g


jlox: Lox.o Token.o Scanner.o
	${CXX} ${LDFLAGS} -o $@ $^

Lox.o: Lox.cpp Lox.h

Token.o: Token.cpp Token.h TokenType.h

Scanner.o: Scanner.cpp Scanner.h

clean:
	rm -f jlox *.o

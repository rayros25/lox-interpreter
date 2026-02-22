# I feel like I should write something here.

CXX      = clang++
CXXFLAGS = -Wall -Wextra -Wreturn-type -g
LDFLAGS  = -g

#include <stdlib.h>
#include <sysexits.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <list>

#include "Lox.h"
#include "Token.h"
#include "Scanner.h"


jlox: main.o Lox.o Token.o Scanner.o Object.o
	${CXX} ${LDFLAGS} -o $@ $^

ast_printer: AstPrinter.o Expr.o Token.o Object.o
	${CXX} ${LDFLAGS} -o $@ $^

main.o: main.cpp Lox.o Lox.h

Lox.o: Lox.cpp Lox.h Token.h Scanner.h

Token.o: Token.cpp Token.h TokenType.h Object.h

Scanner.o: Scanner.cpp Scanner.h Lox.h Token.h TokenType.h Object.h

Object.o: Object.cpp Object.h

Expr.o: Expr.cpp Expr.h Object.h Token.h

AstPrinter.o: AstPrinter.cpp Expr.h Object.h Token.h

clean:
	rm -f jlox *.o

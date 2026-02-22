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


generate_ast: GenerateAst.o
	${CXX} ${LDFLAGS} -o $@ $^

GenerateAst.o: GenerateAst.cpp

clean:
	rm -f generate_ast *.o

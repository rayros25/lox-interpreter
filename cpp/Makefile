# I feel like I should write something here.

CXX      = clang++
CXXFLAGS = -Wall -Wextra -Wreturn-type -g
LDFLAGS  = -g


jlox: Lox.o
	${CXX} ${LDFLAGS} -o $@ $^

Lox.o: Lox.cpp Lox.h

clean:
	rm -f jlox *.o

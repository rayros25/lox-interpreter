#ifndef __TOKEN_H__
#define __TOKEN_H__

#include "TokenType.h"

class Token {
public:
    TokenType type;
    std::string lexeme;
    Object literal; // ????
    int line;

    Token(TokenType type, std::string lexeme, Object literal, int line);
    std::string toString();
};

#endif

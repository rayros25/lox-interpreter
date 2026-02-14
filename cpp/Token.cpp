#include <stdlib.h>
#include "Token.h"
#include "Object.h"

Token::Token(TokenType type, std::string lexeme, Object literal, int line) {
    this->type = type;
    this->lexeme = lexeme;
    this->literal = literal;
    this->line = line;
}

std::string Token::toString() {
    // return type + " " + lexeme + " " + literal;
    return "TODO: TokenType to string" + lexeme + " " + literal.toString();
}

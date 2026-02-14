#include <stdlib.h>
#include "Token.h"
#include "Object.h"

Token::Token(TokenType type, std::string lexeme, Object literal, int line) {
    this->type = type;
    this->lexeme = lexeme;
    this->literal = literal;
    this->line = line;
}

// TODO: This works, right?
std::string Token::typeToString(TokenType type) {
    std::string typearr[39] = { "LEFT_PAREN", "RIGHT_PAREN", "LEFT_BRACE", "RIGHT_BRACE",
         "COMMA", "DOT", "MINUS", "PLUS", "SEMICOLON", "SLASH", "STAR", "BANG",
         "BANG_EQUAL", "EQUAL", "EQUAL_EQUAL", "GREATER", "GREATER_EQUAL",
         "LESS", "LESS_EQUAL", "IDENTIFIER", "STRING", "NUMBER", "AND",
         "CLASS", "ELSE", "FALSE", "FUN", "FOR", "IF", "NIL", "OR", "PRINT",
         "RETURN", "SUPER", "THIS", "TRUE", "VAR", "WHILE", "ENDOF" };
    return typearr[type];
}

std::string Token::toString() {
    // return type + " " + lexeme + " " + literal;
    return typeToString(type) + " " + lexeme + " " + literal.toString();
}


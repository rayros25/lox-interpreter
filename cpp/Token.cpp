#include "Token.h"

using namepsace std;

Token::Token(TokenType type, string lexeme, Object literal, int line) {
    this.type = type;
    this.lexeme = lexeme;
    this.literal = literal;
    this.line = line;
}

string Token::toString() {
    return type + " " + lexeme + " " + literal;
}

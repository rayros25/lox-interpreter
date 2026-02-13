#include "Scanner.h"
#include "Token.h"

using namespace std;

Scanner::Scanner(string source) {
    this.source = source;
    // I think tokens is already initialized
}

list<Token> Scanner::scanTokens {
    while (not isAtEnd()) {
        start = current;
        scanToken();
    }

    tokens.pushback(Token(ENDOF, "", NULL, line))
    return tokens;
}
// private:
//     string source;
//     list<Token> tokens;

//     void scanToken();
//     void identifier();
//     void number();
//     void string();
//     bool match(char expected);
//     char peek();
//     char peekNext();
//     bool isAlpha(char c);
//     bool isDigit(char c)
//     bool isAlphaNumeric(char c);
bool Scanner::isAtEnd() {
    return current >= source.length();
}
//     char advance();
//     void addToken(TokenType type);
//     void addToken(TokenType type, Object literal);
// }

#ifndef __SCANNER_H__
#define __SCANNER_H__

#include <list>
#include <unordered_map>
#include "Token.h"

// using namespace std;

class Scanner {
public:
    Scanner(std::string source);
    std::list<Token> scanTokens();
private:
    std::string source;
    std::list<Token> tokens;
    int start = 0;
    int current = 0;
    int line = 1;
    std::unordered_map<std::string, TokenType> keywords;

    void scanToken();
    void identifier();
    void number();
    void string();
    bool match(char expected);
    char peek();
    char peekNext();
    bool isAlpha(char c);
    bool isDigit(char c);
    bool isAlphaNumeric(char c);
    bool isAtEnd();
    char advance();
    void addToken(TokenType type);
    void addToken(TokenType type, Object literal);
};

#endif

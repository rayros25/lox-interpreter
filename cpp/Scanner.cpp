#include <unordered_map>
#include "Lox.h"
#include "Scanner.h"
#include "Token.h"
#include "TokenType.h"
#include "Object.h"

// Bruh.
// static const std::unordered_map<std::string, TokenType> keywords;
// static const std::unordered_map<std::string, TokenType> keywords = {
// std::unordered_map<std::string, TokenType> keywords = {
//     { "and",    AND },
//     { "class",  CLASS },
//     { "else",   ELSE },
//     { "false",  FALSE },
//     { "for",    FOR },
//     { "fun",    FUN },
//     { "if",     IF },
//     { "nil",    NIL },
//     { "or",     OR },
//     { "print",  PRINT },
//     { "return", RETURN },
//     { "super",  SUPER },
//     { "this",   THIS },
//     { "true",   TRUE },
//     { "var",    VAR },
//     { "while",  WHILE }
// };

Scanner::Scanner(std::string source) {
    this->source = source;
    // I think tokens is already initialized
}

std::list<Token> Scanner::scanTokens() {
    while (not isAtEnd()) {
        start = current;
        scanToken();
    }

    tokens.push_back(Token(ENDOF, "", Object(), line));
    return tokens;
}

void Scanner::scanToken() {
    char c = advance();
    switch (c) {
        case '(': addToken(LEFT_PAREN); break;
        case ')': addToken(RIGHT_PAREN); break;
        case '{': addToken(LEFT_BRACE); break;
        case '}': addToken(RIGHT_BRACE); break;
        case ',': addToken(COMMA); break;
        case '.': addToken(DOT); break;
        case '-': addToken(MINUS); break;
        case '+': addToken(PLUS); break;
        case ';': addToken(SEMICOLON); break;
        case '*': addToken(STAR); break;
        // Two spaces? Why not.
        case '!':
          addToken(match('=') ? BANG_EQUAL : BANG);
          break;
        case '=':
          addToken(match('=') ? EQUAL_EQUAL : EQUAL);
          break;
        case '<':
          addToken(match('=') ? LESS_EQUAL : LESS);
          break;
        case '>':
          addToken(match('=') ? GREATER_EQUAL : GREATER);
          break;
        case '/':
          if (match('/')) {
              // This is a comment!
              while (peek() != '\n' and not isAtEnd()) { advance(); }
          } else {
              addToken(SLASH);
          }
          break;
        case ' ':
        case '\r':
        case '\t':
          // Ignore whitespace.
          break;
        case '\n':
          line++;
          break;
        case '"': string(); break;
        default:
          if (isDigit(c)) {
            number();
          } else if (isAlpha(c)) {
            identifier();
          } else {
              Lox::error(line, "Unexpected character.");
          }
          break;
    }
}

void Scanner::identifier() {
    while (isAlphaNumeric(peek())) { advance(); }

    std::string text = source.substr(start, current);
    TokenType type;
    // try {
    //     type = keywords.at(text);
    // } catch (std::out_of_range e) {
    //     type = IDENTIFIER;
    // }
    type = IDENTIFIER;
    addToken(type);
}

void Scanner::number() {
    while (isDigit(peek())) { advance(); }

    // Look for a fractional part.
    if (peek() == '.' and isDigit(peekNext())) {
        // Consume the "."
        advance();

        while (isDigit(peek())) { advance(); }
    }

    addToken(NUMBER, std::stod(source.substr(start, current)));
}

void Scanner::string() {
    while (peek() != '"' and not isAtEnd()) {
        if (peek() == '\n') line++;
        advance();
    }

    if (isAtEnd()) {
        Lox::error(line, "Unterminated string.");
        return;
    }

    // The closing ".
    advance();

    // Trim the surrounding quotes.
    std::string value = source.substr(start + 1, current - 1);
    addToken(STRING, value);
}

bool Scanner::match(char expected) {
    if (isAtEnd()) return false;
    if (source[current] != expected) return false;

    current++;
    return true;
}

char Scanner::peek() {
    if (isAtEnd()) return '\0';
    return source[current];
}

char Scanner::peekNext() {
    if (current + 1 >= (int)source.length()) return '\0';
    return source[current + 1];
}

bool Scanner::isAlpha(char c) {
    return (c >= 'a' and c <= 'z') or
           (c >= 'A' and c <= 'Z') or
            c == '_';
}

bool Scanner::isDigit(char c) {
    return c >= '0' and c <= '9';
}

bool Scanner::isAlphaNumeric(char c) {
    return isAlpha(c) or isDigit(c);
}

bool Scanner::isAtEnd() {
    return current >= (int)source.length();
}

char Scanner::advance() {
    return source[current++];
}

void Scanner::addToken(TokenType type) {
    addToken(type, Object());
}

void Scanner::addToken(TokenType type, Object literal) {
    std::string text = source.substr(start, current);
    tokens.push_back(Token(type, text, literal, line));
}

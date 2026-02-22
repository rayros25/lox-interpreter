#include <stdlib.h>
#include <sysexits.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <list>

#include "Lox.h"
#include "Token.h"
#include "Scanner.h"

using namespace std;

bool Lox::hadError = false;

int Lox::main(int argc, char* argv[]) {
    if (argc > 2) {
        cout << "Usage: jlox [script]" << endl;
        exit(EX_USAGE);
    } else if (argc == 2) {
        runFile(argv[1]);
    } else {
        runPrompt();
    }

    return EXIT_SUCCESS;
}

void Lox::runFile(string path) {
    ifstream infile(path);
    stringstream bufstream;
    bufstream << infile.rdbuf();
    run(bufstream.str());

    if (hadError) exit(EX_DATAERR);
}

void Lox::runPrompt() {
    for (;;) {
        cout << "> ";
        string line;
        getline(cin, line);
        if (cin.eof()) break;
        run(line);
        hadError = false;
    }
}

void Lox::run(string source) {
    Scanner scanner(source);
    list<Token> tokens = scanner.scanTokens();

    for (Token token : tokens) {
        cout << token.toString() << endl;
    }
}

void Lox::error(int line, string message) {
    report(line, "", message);
}

void Lox::report(int line, string where, string message) {
    cerr << "[line " << line << "] Error" << where << ": " << message << endl;
    hadError = true;
}

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

bool hadError = false; // Yes, it's a global variable, sue me.

int main(int argc, char* argv[]) {
    if (argc > 2) {
        cout << "Usage: jlox [script]" << endl;
        exit(EX_USAGE);
    } else if (argc == 2) {
        runFile(argv[1]);
    } else {
        runPrompt();
    }

    return 0; // TODO: change this to something nice
}

void runFile(string path) {
    ifstream infile(path);
    stringstream bufstream;
    bufstream << infile.rdbuf();
    run(bufstream.str());

    if (hadError) exit(EX_DATAERR);
}

void runPrompt() {
    for (;;) {
        cout << "> ";
        string line;
        cin >> line;
        if (cin.eof()) break;
        run(line);
        hadError = false;
    }
}

    // Scanner scanner = new Scanner(source);
    // List<Token> tokens = scanner.scanTokens();
    //
    // // For now, just print the tokens.
    // for (Token token : tokens) {
    //   System.out.println(token);
    // }
void run(string source) {
    Scanner scanner(source);
    list<Token> tokens = scanner.scanTokens();

    for (Token token : tokens) {
        cout << token.toString() << endl;
    }
}


void error(int line, string message) {
    report(line, "", message);
}

void report(int line, string where, string message) {
    cerr << "[line " << line << "] Error" << where << ": " << message << endl;
    hadError = true;
}

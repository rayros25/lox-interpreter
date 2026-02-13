#ifndef LOX_H
#define LOX_H

using namespace std;

void runFile(string path);
void runPrompt();
void run(string source);
void error(int line, string message);
void report(int line, string where, string message);

#endif

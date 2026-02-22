#ifndef LOX_H
#define LOX_H

#include <string>

class Lox {
public:
    static bool hadError;

    static int main(int argc, char* argv[]);
    static void error(int line, std::string message);
private:
    static void runFile(std::string path);
    static void runPrompt();
    static void run(std::string source);
    static void report(int line, std::string where, std::string message);
};

#endif

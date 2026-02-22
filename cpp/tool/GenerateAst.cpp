#include <stdlib.h>
#include <sysexits.h>
#include <string>
#include <iostream>
// #include <fstream>
// #include <sstream>
// #include <list>

// #include "Lox.h"
// #include "Token.h"
// #include "Scanner.h"

using namespace std;

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: generate_ast <output directory>" << endl;
        exit(EX_USAGE);
    } else {
        string outputDir = argv[1];
    }

    return EXIT_SUCCESS;
}

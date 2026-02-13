#include <stdlib.h>
#include <sysexits.h>
#include <iostream>
#include <fstream>
#include <sstream>

#include "Lox.h"

// using namespace std;

int main(int argc, char* argv[]) {
    if (argc > 2) {
        cout << "Usage: jlox [script]" << endl;
        exit(EX_USAGE);
    } else if (argc == 2) {
        runFile(argv[0]);
    } else {
        runPrompt();
    }

    return 0; // TODO: change this to something nice
}

  // private static void runFile(String path) throws IOException {
  //   byte[] bytes = Files.readAllBytes(Paths.get(path));
  //   run(new String(bytes, Charset.defaultCharset()));
  // }
void runFile(string path) {
    cout << "RUNNING:" << path << endl;
    ifstream infile(path);
    // ifstream infile;
    // infile.open(path);
    // if (not infile.is_open()) {
    //     cerr << "Error: Could not open file" << endl;
    //     exit(EX_NOINPUT);
    // }
    stringstream bufstream;
    bufstream << infile.rdbuf();
    run(bufstream.str());
}

  // private static void runPrompt() throws IOException {
  //   InputStreamReader input = new InputStreamReader(System.in);
  //   BufferedReader reader = new BufferedReader(input);
  //
  //   for (;;) { 
  //     System.out.print("> ");
  //     String line = reader.readLine();
  //     if (line == null) break;
  //     run(line);
  //   }
  // }
void runPrompt() {
    for (;;) {
        cout << "> ";
        string line;
        cin >> line;
// TODO: if EOF, then break
        run(line);
    }
}

void run(string source) {
    (void)source;
}

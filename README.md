# Lox Interpreter(s)

These are my various attempts to implement an interpreter for Lox, a language created by Robert Nystorm
for his book ["Crafting Interpreters"](https://craftinginterpreters.com/). This project couldn't exist without his writings.

The only complete interpreter right now is the one in Ruby. Both the Java and C++ implementations are works in progress.
All three of them are implementations based on Nystorm's `jlox` interpreter from the first half of the book, which
is a tree-walk interpreter. I plan on continuing the book, which implements a bytecode VM interpreter in C (fittingly called `clox`).

# Programs

I've written a few small test programs in Lox. They're located in the `bin` directory. The interpreters themselves are in
the other directories.


## Usage

(Of course, you must have Ruby installed first.)

1. Clone this directory.
2. `cd` into the `ruby` directory.
3. Run `./rlox`, optionally followed by the path to a Lox script.

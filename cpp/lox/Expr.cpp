#include "Expr.h"

class Expr {
};


class Binary : public Expr {
    Binary(Expr left, Token opera, Expr right) {
        this->left = left;
        this->opera = opera;
        this->right = right;
    }
};


class Literal : public Expr {
    Literal(Object value) {
        this->value = value;
    }
};

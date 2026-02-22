#ifndef __EXPR_H__
#define __EXPR_H__

#include "Object.h"
#include "Token.h"

class Expr {
public:
    class Binary {
        public:
        // operator is a reserved name
        Binary(Expr left, Token opera, Expr right);

        Expr left;
        Token opera;
        Expr right;
    };

    class Literal {
        public:
        Literal(Object value);

        Object value;
    };
};

#endif

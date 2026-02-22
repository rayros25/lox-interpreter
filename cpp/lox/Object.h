#ifndef __OBJECT_H__
#define __OBJECT_H__

#include <string>

// The whole point of this class is to dance around the polymorphism used in
// the book.
class Object {

public:
    Object(double d);
    Object(std::string s);
    Object();
    std::string toString();
private:
    double d;
    std::string s;
    bool isString;
    bool isNull;
};

#endif

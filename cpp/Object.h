#ifndef __OBJECT_H__
#define __OBJECT_H__

#include <string>

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

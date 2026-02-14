#include <string>

#include "Object.h"

Object::Object(double d) {
    this->d = d;
    this->isString = false;
    this->isNull = false;
}

Object::Object(std::string s) {
    this->s = s;
    this->isString = true;
    this->isNull = false;
}

Object::Object() {
    this->isNull = true;
}

std::string Object::toString() {
    if (this->isNull) {
        return "";
    } else if (this->isString) {
        return this->s;
    } else {
        return std::to_string(this->d);
    }
}

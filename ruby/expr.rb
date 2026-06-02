# Thanks a billion to why the lucky stiff for writing their poignant guide,
# specifically the chapter on metaprogramming. Couldn't have done it without
# you
#
# https://poignant.guide/book/chapter-6.html
class Expr
  def self.metaclass; class << self; self; end; end

  def self.traits( *arr )
    return @traits if arr.empty?

    attr_accessor( *arr )
    @traits = arr

    class_eval do
      define_method( :initialize ) do |test|
        self.class.traits.zip(test).each do |k,v|
          instance_variable_set("@#{k}", v)
        end
      end

      define_method( :accept ) do |visitor|
        name = eval("self.class.name + self.class.superclass.name")
        eval("return visitor.visit#{name}(self)")
      end
    end
  end
end


class Assign < Expr
  traits :name, :value
end

class Binary < Expr
  traits :left, :operator, :right
end

class Call < Expr
  traits :callee, :paren, :arguments
end

class Get < Expr
  traits :object, :name
end

class Literal < Expr
  traits :value
end

class Logical < Expr
  traits :left, :operator, :right
end

class Grouping < Expr
  traits :expression
end

# Same story with "Class" and "MyClass"
class MySet < Expr
  traits :object, :name, :value
end

class Super < Expr
  traits :keyword, :method
end

class This < Expr
  traits :keyword
end

class Unary < Expr
  traits :operator, :right
end

class Variable < Expr
  traits :name
end

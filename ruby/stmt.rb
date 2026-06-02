# Thanks a billion to why the lucky stiff for writing their poignant guide,
# specifically the chapter on metaprogramming. Couldn't have done it without
# you
#
# https://poignant.guide/book/chapter-6.html
class Stmt
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
        eval("return visitor.visit" + name + "(self)")
      end
    end
  end
end


class Block < Stmt
  traits :statements
end

# NOTE: Named "Class" in the source code.
class MyClass < Stmt
  traits :name, :superclass, :methods
end

class Expression < Stmt
  traits :expression
end

class Function < Stmt
  traits :name, :params, :body
end

class If < Stmt
  traits :condition, :thenBranch, :elseBranch
end

class Print < Stmt
  traits :expression
end

class Return < Stmt
  traits :keyword, :value
end

class Var < Stmt
  traits :name, :initializer
end

class While < Stmt
  traits :condition, :body
end

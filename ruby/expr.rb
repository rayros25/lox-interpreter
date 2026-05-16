# Thanks a billion to why the lucky stiff for writing their poignant guide,
# specifically the chapter on metaprogramming. Couldn't have done it without
# you
#
# https://poignant.guide/book/chapter-6.html
class Expr

  # Get a metaclass for this class
  def self.metaclass; class << self; self; end; end

  # Advanced metaprogramming code
  def self.traits( *arr )
    return @traits if arr.empty?

    # 1. Set up accesors for each variable
    attr_accessor( *arr )


    @traits = arr # DOES THIS WORK????
    # 2. Add a new class method for each trait.
    # arr.each do |a|
    #   metaclass.instance_eval do
    #     define_method( a ) do |val|
    #       @traits ||= {}
    #       @traits[a] = val
    #     end
    #   end
    # end

    # 3. For each monster, the initialize method should use the default number for each trait
    class_eval do
      define_method( :initialize ) do |test|
        # @traits = arr
        # puts test
        # puts self.class.traits
        self.class.traits.zip(test).each do |k,v|
          instance_variable_set("@#{k}", v)
        end
        # self.class.traits.each do |k,v|
        #   instance_variable_set("@#{k}", v)
        # end
      end

      # This should work, right?
      define_method( :accept ) do |visitor|
        name = eval("self.class.name + self.class.superclass.name")
        eval("return visitor.visit" + name + "(self)")
      end
    end

  end

  # Creature attributes are read-only
  # traits :life, :strength, :charisma, :weapon
end

class Assign < Expr
  traits :name, :value
end

class Binary < Expr
  traits :left, :operator, :right
  # def initialize ( left, operator, right )
  #   @left = left
  #   @operator = operator
  #   @right = right
  # end

  # def accept visitor
  #   return visitor.visitBinaryExpr(self)
  # end
end

class Call < Expr
  traits :callee, :paren, :arguments
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

class Unary < Expr
  traits :operator, :right
end

class Variable < Expr
  traits :name
end

# Thanks a billion to why the lucky stiff for writing their poignant guide,
# specifically the chapter on metaprogramming. Couldn't have done it without
# you
#
# https://poignant.guide/book/chapter-6.html
class Stmt

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

class Block < Stmt
  traits :statements
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

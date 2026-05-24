require "./loxcallable"
require "./loxinstance"

class LoxClass
  include LoxCallable # More of a formality, really

  attr_accessor :name

  def initialize( name, superclass, methods )
    @name = name
    @superclass = superclass
    @methods = methods
  end

  def findMethod( name )
    if @methods.has_key? name
      return @methods[name]
    end

    if @superclass
      return @superclass.findMethod( name )
    end

    return nil
  end

  def call( interpreter, arguments )
    instance = LoxInstance::new( self )
    initializer = findMethod "init"
    if initializer
      initializer.bind( instance ).call( interpreter, arguments )
    end
    return instance
  end

  def arity
    initializer = findMethod "init"
    unless initializer
      return 0
    end
    return initializer.arity
  end

  def to_s
    @name
  end
end

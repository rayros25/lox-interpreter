require "./loxcallable"
require "./loxinstance"

class LoxClass
  include LoxCallable # More of a formality, really

  attr_accessor :name

  def initialize( name, methods )
    @name = name
    @methods = methods
  end

  def findMethod( name )
    if @methods.has_key? name
      return @methods[name]
    end

    return nil
  end

  def call( interpreter, arguments )
    instance = LoxInstance::new( self )
    return instance
  end

  def arity
    0
  end

  def to_s
    @name
  end
end

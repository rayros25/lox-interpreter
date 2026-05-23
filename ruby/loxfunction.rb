require "./environment"
require "./returnobj"

class LoxFunction
  include LoxCallable

  def initialize( declaration, closure, isInitializer )
    @declaration = declaration
    @closure = closure
    @isInitializer = isInitializer
  end

  def bind( instance )
    environment = Environment::new( @closure )
    environment.define( "this", instance )
    return LoxFunction::new( @declaration, environment, @isInitializer )
  end

  def call( interpreter, arguments )
    environment = Environment::new( @closure )

    for i in 0...@declaration.params.length do
      environment.define( @declaration.params[i].lexeme, arguments[i] )
    end

    begin
      interpreter.executeBlock( @declaration.body, environment )
    rescue ReturnObj => returnValue
      if @isInitializer
        return @closure.getAt(0, "this")
      end

      return returnValue.value
    end

    if @isInitializer
      return @closure.getAt(0, "this")
    end
    return nil
  end

  def arity
    return @declaration.params.length
  end

  def to_s
    return "<fn #{@declaration.name.lexeme}>"
  end

end

require "./environment"
require "./returnobj"

class LoxFunction
  include LoxCallable

  def initialize( declaration, closure )
    @declaration = declaration
    @closure = closure
  end

  def call( interpreter, arguments )
    environment = Environment::new( @closure )

    for i in 0...@declaration.params.length do
      environment.define( @declaration.params[i].lexeme, arguments[i] )
    end

    begin
      interpreter.executeBlock( @declaration.body, environment )
    rescue ReturnObj => returnValue
    # rescue RuntimeError => returnValue
      return returnValue.value
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

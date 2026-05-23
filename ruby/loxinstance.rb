require "./loxruntimeerror"

class LoxInstance
  def initialize( klass )
    @klass = klass
    @fields = Hash.new
  end

  def get( name )
    if @fields.has_key? name.lexeme
      return @fields[name.lexeme]
    end

    method = @klass.findMethod( name.lexeme )
    return method if method

    raise LoxRuntimeError::new(name, "Undefined property '#{name.lexeme}'.")
  end

  def set( name, value )
    @fields[name.lexeme] = value
  end

  def to_s
    @klass.name + " instance"
  end
end

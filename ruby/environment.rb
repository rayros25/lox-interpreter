require "./loxruntimeerror"

class Environment
  def initialize( enclosing = nil )
    @values = {}
    @enclosing = enclosing
  end

  def get( name )
    if @values.key? name.lexeme
      return @values[name.lexeme]
    end

    return @enclosing.get( name ) if @enclosing

    raise LoxRuntimeError::new( name, "Undefined variable '#{name.lexeme}'." )
  end

  def assign( name, value )
    if @values.key? name.lexeme
      @values[name.lexeme] = value
      return
    end

    if @enclosing
      @enclosing.assign( name, value )
      return
    end

    raise LoxRuntimeError::new( name, "Undefined variable '#{name.lexeme}'." )
  end

  def define( name, value )
    @values[name] = value
  end

  def ancestor( distance )
    environment = self
    distance.times do
      environment = environment.enclosing
    end

    return environment
  end

  def getAt( distance, name )
    return ancestor( distance ).values[name]
  end

  def assignAt( distance, name, value )
    ancestor( distance ).values[name.lexeme] = value
  end
end

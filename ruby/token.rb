class Token
  def initialize( type, lexeme, literal, line )
    @type = type
    @lexeme = lexeme
    @literal = literal
    @line = line
  end

  def to_s
    return @type.to_s.upcase + " " + @lexeme + " " + @literal.to_s
  end
end

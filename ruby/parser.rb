require "./lox"
require "./expr"

class Parser

  class ParseError < StandardError
  end

  ## PUBLIC ##
  def initialize( tokens )
    @tokens = tokens
    @current = 0
  end

  def parse
    begin
      return expression
    rescue ParseError => error
      return nil
    end
  end

  ## PRIVATE ##
  def expression
    return equality
  end

  def equality
    expr = comparison

    while match(:bang_equal, :equal_equal)
      operator = previous
      right = comparison
      expr = Binary::new([ expr, operator, right ])
    end

    return expr
  end

  def comparison
    expr = term

    while match( :greater, :greater_equal, :less, :less_equal )
      operator = previous
      right = term
      expr = Binary::new([ expr, operator, right ])
    end

    return expr
  end

  def term
    expr = factor

    while match( :minus, :plus )
      operator = previous
      right = factor
      expr = Binary::new([ expr, operator, right ])
    end

    return expr
  end

  def factor
    expr = unary

    while match( :slash, :star )
      operator = previous
      right = unary
      expr = Binary::new([ expr, operator, right ])
    end

    return expr
  end

  def unary
    if match( :bang, :minus )
      operator = previous
      right = unary
      return Unary::new([ operator, right ])
    end

    return primary
  end

  def primary
    return Literal::new([ false ]) if match( :false )
    return Literal::new([  true ]) if match(  :true )
    return Literal::new([   nil ]) if match(   :nil )

    if match( :number, :string )
      return Literal::new([ previous().literal ])
    end

    if match( :left_paren )
      expr = expression
      consume( :right_paren, "Expect ')' after expression." )
      return Grouping::new([ expr ])
    end

    raise error( peek, "Expect expresson." )
  end

  def match( *types )
    types.each do |type|
      if check(type)
        advance
        return true
      end
    end

    return false
  end

  def consume( type, message )
    return advance if check( type )

    raise error(peek(), message)
  end

  def check( type )
    return false if isAtEnd
    return peek().type == type
  end

  def advance
    @current += 1 unless isAtEnd
    return previous
  end

  def isAtEnd
    return peek().type == :eof
  end

  def peek
    return @tokens[@current]
  end

  def previous
    return @tokens[@current - 1]
  end

  def error( token, message )
    Lox::error( token, message )
    return ParseError::new
  end

  def synchronize
    advance

    until isAtEnd
      return if previous().type == :semicolon

      case peek().type
      when :class, :fun, :var, :for, :if, :while, :print, :return
        return
      end

      advance
    end
  end
end

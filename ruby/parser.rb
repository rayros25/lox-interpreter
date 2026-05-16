require "./lox"
require "./expr"
require "./stmt"

class Parser

  class ParseError < StandardError
  end

  ## PUBLIC ##
  def initialize( tokens )
    @tokens = tokens
    @current = 0
  end

  def parse
    statements = []

    until isAtEnd
      statements << declaration()
    end

    return statements
  end

  ## PRIVATE ##
  def expression
    return assignment
  end

  def declaration
    begin
      return varDeclaration if match :var
      return statement
    rescue ParseError
      synchronize
      return nil
    end
  end

  def statement
    return forStatement if match :for
    return ifStatement if match :if
    return printStatement if match :print
    return whileStatement if match :while
    return Block::new([ block ]) if match :left_brace
    return expressionStatement
  end

  def forStatement
    consume(:left_paren, "Expect '(' after 'for'.")

    initializer = nil
    if match :semicolon
      initializer = nil # TODO: clean up
    elsif match :var
      initializer = varDeclaration
    else
      initializer = expressionStatement
    end

    condition = nil
    unless check :semicolon
      condition = expression
    end
    consume( :semicolon, "Expect ';' after loop condition." )

    increment = nil
    unless check :right_paren
      increment = expression
    end
    consume( :right_paren, "Expect ')' after for clauses." )

    body = statement

    if increment
      body = Block::new([ [body, Expression::new([ increment ])] ]) # Damn.
    end

    condition = Literal::new([ true ]) if condition.nil?
    body = While::new([ condition, body ])

    if initializer
      body = Block::new([ [initializer, body] ])
    end

    return body
  end

  def ifStatement
    consume(:left_paren, "Expect '(' after 'if'.")
    condition = expression
    consume(:right_paren, "Expect ')' after if condition.")

    thenBranch = statement
    elseBranch = nil
    if match :else
      elseBranch = statement
    end

    return If::new([ condition, thenBranch, elseBranch ])
  end

  def printStatement
    value = expression
    consume( :semicolon, "Expect ';' after value." )
    return Print::new([ value ])
  end

  def expressionStatement
    expr = expression
    consume( :semicolon, "Expect ';' after expression." )
    return Expression::new([ expr ])
  end

  def block
    statements = []

    until check( :right_brace ) or isAtEnd
      statements << declaration
    end
    
    consume( :right_brace, "Expect '}' after block." )
    return statements
  end

  def assignment
    expr = logor
    
    if match :equal
      equals = previous
      value = assignment

      if expr.is_a? Variable
        return Assign::new([ expr.name, value ])
      end

      error( equals, "Invalid assignment target." )
    end

    return expr
  end

  # Called "or" in the source code, but that's reserved in Ruby.
  # So "logor" instead, short for "logical or."
  def logor
    expr = logand

    while match :or
      operator = previous
      right = logand
      expr = Logical::new([ expr, operator, right ])
    end

    return expr
  end

  # Same story as above.
  def logand
    expr = equality

    while match :and
      operator = previous
      right = equality
      expr = Logical::new([ expr, operator, right ])
    end

    return expr
  end

  def varDeclaration
    name = consume( :identifier, "Expect variable name." )

    initializer = nil
    if match :equal
      initializer = expression
    end

    consume( :semicolon, "Expect ';' after variable declaration." )
    return Var::new([ name, initializer ])
  end

  def whileStatement
    consume( :left_paren, "Expect '(' after 'while'.")
    condition = expression
    consume( :right_paren, "Expect ')' after condition.")
    body = statement

    return While::new([ condition, body ])
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

    return call
  end

  def call
    expr = primary

    loop do
      if match :left_paren
        expr = finishCall expr
      else
        break
      end
    end

    return expr
  end

  def primary
    return Literal::new([ false ]) if match( :false )
    return Literal::new([  true ]) if match(  :true )
    return Literal::new([   nil ]) if match(   :nil )

    if match( :number, :string )
      return Literal::new([ previous().literal ])
    end

    if match( :identifier )
      return Variable::new([ previous ])
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

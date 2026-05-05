require "./lox"
require "./token"

class Scanner
  def initialize( source )
    @source = source
    @tokens = []
    @start = 0
    @current = 0
    @line = 1

    @keywords = { 
      'and' => :and,
      'class' => :class,
      'else' => :else,
      'false' => :false,
      'for' => :for,
      'fun' => :fun,
      'if' => :if,
      'nil' => :nil,
      'or' => :or,
      'print' => :print,
      'return' => :return,
      'super' => :super,
      'this' => :this,
      'true' => :true,
      'var' => :var,
      'while' => :while
    }
  end

  def scanTokens
    until isAtEnd
      @start = @current
      scanToken
    end

    @tokens << Token::new(:eof, "", nil, @line)
    return @tokens
  end

  def isAtEnd
    @current >= @source.length
  end

  def scanToken
    c = advance
    # switch statement
    case c
    when '('
      addToken(:left_paren)
    when ')'
      addToken(:right_paren)
    when '{' 
      addToken(:right_brace)
    when '}' 
      addToken(:right_brace)
    when ',' 
      addToken(:comma)
    when '.' 
      addToken(:dot)
    when '+' 
      addToken(:plus)
    when '-' 
      addToken(:minus)
    when '*' 
      addToken(:star)
    when ';' 
      addToken(:semicolon)
    when '!'
      addToken(:bang_equal ? match('=') : :bang)
    when '='
      addToken(:equal_equal ? match('=') : :equal)
    when '>'
      addToken(:greater_equal ? match('=') : :greater)
    when '<'
      addToken(:less_equal ? match('=') : :less)
    when '/'
      if match('/')
        # A comment goes until the end of the line.
        while peek != "\n" && !isAtEnd
          advance
        end
      else
        addToken(:slash)
      end
    when " "
    when "\r"
    when "\t"
    when "\n"
      @line += 1
    when '"'
      string
    else
      if isDigit(c)
        number
      elsif isAlpha(c)
        identifier
      else
        Lox::error(@line, "Unexpected character.")
      end
    end
  end

  def advance
    curr = @source[@current]
    @current += 1
    return curr
  end

  def addToken( *args )
    case args.size
    when 1
      # def addToken( type )
      #   addToken(type, nil)
      # end
      addToken(args[0], nil)
    when 2
      # def addToken( type, literal )
      #   text = @source[@start, @current]
      #   @tokens << Token.new(type, text, literal, @line)
      # end
      text = @source[@start..@current - 1]
      @tokens << Token.new(args[0], text, args[1], @line)
    end
  end

  def match( expected )
    if isAtEnd
      return false
    end

    if @source[@current] != expected
      return false
    end

    @current += 1
    return true
  end

  def peek
    if isAtEnd
      return nil
    end
      return @source[@current]
  end

  def peekNext
    if @current + 1 >= @source.length
      return nil
    end
    return @source[@current + 1]
  end

  def string
    while peek != '"' && !isAtEnd
      if peek == "\n"
        @line += 1
      end
      advance
    end
    
    if isAtEnd
      Lox::error(@line, "Unterminated string.")
      return
    end

    # The closing ".
    advance

    # Trim the surrounding quotes.
    value = @source[@start + 1..@current - 2]
    addToken(:string, value)
  end

  def isDigit( c )
    return ('0'..'9') === c
  end

  def isAlpha( c )
    return ('a'..'z') === c || ('A'..'Z') === c || c == "_"
  end

  def isAlphaNumeric( c )
    return isDigit(c) || isAlpha(c)
  end

  def identifier
    while isAlphaNumeric peek
      advance
    end
    text = @source[@start..@current - 1]
    type = @keywords[text]
    unless type
      type = :identifier
    end
    addToken(type)
  end

  def number
    while isDigit( peek )
      advance
    end

    # Look for a fractional part.
    if peek == '.' && isDigit( peekNext )
      # Consume the "."
      advance
      while isDigit( peek )
        advance
      end
    end

    addToken(:number, @source[@start..@current - 1].to_f)
  end

end

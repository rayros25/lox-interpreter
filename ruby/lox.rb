require "./scanner"
require "./parser"
require "./astprinter"

class Lox
  @@hadError = false
  # def initialize
  # end

  ### PUBLIC ###
  def Lox.main( args )
    if args.length > 1
      puts "Usage: rlox [script]"
      exit(64)
    elsif args.length == 1
      Lox::runFile( args[0] )
    else
      Lox::runPrompt
    end
  end

  # TODO: overloading??
  # def Lox.error( line, message )
  #   report( line, "", message )
  # end

  # TODO: Should these be two separate functions?
  def Lox.error( token, message )
    if token.type == :eof
      report( token.line, " at end", message)
    else
      report( token.line, " at '" + token.lexeme + "'", message)
    end
  end

  ### PRIVATE ###
  def Lox.runFile( path )
    run File::read( path )
  end

  def Lox.runPrompt
    loop do
      print "> "
      line = gets
      break unless line
      line.chomp! # Get rid of the \n at the end
      run( line )
    end
  end

  def Lox.run( source )
    scanner = Scanner::new( source )
    tokens = scanner.scanTokens
    parser = Parser::new( tokens )
    expression = parser.parse

    # Stop if there was a syntax error.
    return if @@hadError

    puts AstPrinter::new.print(expression)
  end

  def Lox.report( line, where, message )
    STDERR.puts "[line #{line}] Error#{where}: #{message}"
    @@hadError = true
  end
end

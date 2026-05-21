require "./scanner"
require "./parser"
require "./astprinter"
require "./loxruntimeerror"
require "./interpreter"
require "./resolver"

class Lox
  @@interpreter = Interpreter::new
  @@hadError = false
  @@hadRuntimeError = false
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
      report( token.line, " at '#{token.lexeme}'", message)
    end
  end

  def Lox.runtimeError( error )
    STDERR.puts ( error.getMessage + "\n[line #{error.token.line}]" )
    @@hadRuntimeError = true
  end

  ### PRIVATE ###
  def Lox.runFile( path )
    run File::read( path )

    # Indicate an error in the exit code.
    exit(65) if @@hadError
    exit(70) if @@hadRuntimeError
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
    statements = parser.parse

    # Stop if there was a syntax error.
    return if @@hadError

    resolver = Resolver::new( interpreter )
    resolver.resolve( statements )

    # Sorry, AstPrinter! Time to go.
    # puts AstPrinter::new.print(expression)
    @@interpreter.interpret( statements )
  end

  def Lox.report( line, where, message )
    STDERR.puts "[line #{line}] Error#{where}: #{message}"
    @@hadError = true
  end
end

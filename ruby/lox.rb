require "./scanner"

class Lox
  def initialize
    @@hadError = false
  end

  ### PUBLIC ###
  def Lox.main( args )
    if args.length > 1
      puts "Usage: rlox [script]"
      raise ArgumentError, "64"
      # TODO: Fix above
    elsif args.length == 1
      Lox::runFile( args[0] )
    else
      Lox::runPrompt
    end
  end

  def Lox.error( line, message )
    report( line, "", message )
  end

  ### PRIVATE ###
  def Lox.runFile( path )
    # TODO:
    # run(stuff in file)
  end

  def Lox.runPrompt
    while true
      print "> "
      line = gets
      break unless line
      line.chomp! # Get rid of the \n at the end
      run(line)
    end
  end

  def Lox.run( source )
    scanner = Scanner.new(source)
    tokens = scanner.scanTokens
    tokens.each {|token| puts token}
  end

  def Lox.report( line, where, message )
    STDERR.puts "[line #{line}] Error#{where}: #{message}"
    @@hadError = true
  end
end

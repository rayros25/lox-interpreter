require "./scanner"

class Lox
  # TODO: in initialize: hadError = false?
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
    # run(stuff in file)
  end

  def Lox.runPrompt
    while true
      print "> "
      line = gets
      break unless line
      run(line)
    end
  end

  def Lox.run( source )
    scanner = Scanner.new(source)
    tokens = scanner.scanTokens
    # Scanner scanner = new Scanner(source);
    # tokesn = scanner.scanTokens()
    #
    # for token in tokens
    #   print token
    tokens.each {|token| puts token}
    # print "LINE: ", source
  end

  def Lox.report( line, where, message )
    STDERR.puts "[line #{line}] Error#{where}: #{message}"
    @@hadError = true
  end
end

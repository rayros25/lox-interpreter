require "./lox"

class Resolver
  def initialize( interpreter )
    @interpreter = interpreter
    @scopes = [] # Treat this like a stack.
    @currentFunction = :fnone
    # We simply use symbols for FunctionType. The possible values are:
    # fnone
    # ffunc
    # fmethod
  end

  def visitBlockStmt( stmt )
    beginScope
    resolvelist( stmt.statements )
    endScope
    return nil
  end

  def visitMyClassStmt( stmt )
    declare stmt.name
    define stmt.name

    stmt.methods.each do |method|
      declaration = :fmethod
      resolveFunction( method, declaration )
    end

    return nil
  end

  def visitExpressionStmt( stmt )
    resolve stmt.expression
    return nil
  end

  def visitFunctionStmt( stmt )
    declare stmt.name
    define stmt.name

    resolveFunction( stmt, :ffunc )
    return nil
  end

  def visitIfStmt( stmt )
    resolve stmt.condition
    resolve stmt.thenBranch
    if stmt.elseBranch
      resolve stmt.elseBranch
    end
    return nil
  end

  def visitPrintStmt( stmt )
    resolve stmt.expression
    return nil
  end

  def visitReturnStmt( stmt )
    if @currentFunction == :fnone
      Lox::error( stmt.keyword, "Can't return from top-level code." )
    end
    if stmt.value
      resolve stmt.value
    end
    return nil
  end

  def visitVarStmt( stmt )
    declare stmt.name
    if stmt.initializer
      resolve stmt.initializer
    end
    define stmt.name
    return nil
  end

  def visitWhileStmt( stmt )
    resolve stmt.condition
    resolve stmt.body
    return nil
  end

  def visitAssignExpr( expr )
    resolve expr.value
    resolveLocal( expr, expr.name )
    return nil
  end

  def visitBinaryExpr( expr )
    resolve expr.left
    resolve expr.right
    return nil
  end

  def visitCallExpr( expr )
    resolve expr.callee

    expr.arguments.each do |argument|
      resolve argument
    end

    return nil
  end

  def visitGetExpr( expr )
    resolve expr.object
    return nil
  end

  def visitGroupingExpr( expr )
    resolve expr.expression
    return nil
  end

  def visitLiteralExpr( expr )
    return nil
  end

  def visitLogicalExpr( expr )
    resolve expr.left
    resolve expr.right
    return nil
  end

  def visitMySetExpr( expr )
    resolve expr.value
    resolve expr.object
    return nil
  end

  def visitUnaryExpr( expr )
    resolve expr.right
    return nil
  end

  def visitVariableExpr( expr )
    if !@scopes.empty? && @scopes.last[expr.name.lexeme] == false # TODO: is this right?
      Lox::error( expr.name "Can't read local variable in its own initializer." )
    end

    resolveLocal( expr, expr.name )
    return nil
  end

  # NOTE: Again,  Ruby doesn't have overloading, so I have to rename this.
  def resolvelist( statements )
    statements.each do |statement|
      resolve statement
    end
  end

  # NOTE: This is also resolves expressions
  def resolve( stmt )
    stmt.accept( self )
  end

  def resolveFunction( function, type )
    enclosingFunction = @currentFunction
    @currentFunction = type

    beginScope
    function.params.each do |param|
      declare param
      define param
    end
    resolvelist function.body
    endScope

    @currentFunction = enclosingFunction
  end

  def beginScope
    @scopes.push( Hash.new )
  end

  def endScope
    @scopes.pop
  end

  def declare( name )
    return if @scopes.empty?

    scope = @scopes.last # Ironically, this is the *top* of the stack.
    if scope.has_key? name.lexeme
      Lox::error( name, "Already a variable with this name in this scope." )
    end
    scope[name.lexeme] = false
  end

  def define( name )
    return if @scopes.empty?
    @scopes.last[name.lexeme] = true
  end

  def resolveLocal( expr, name )
    (0..@scopes.length - 1).reverse_each do |i|
      if @scopes[i].has_key? name.lexeme
        @interpreter.resolve( expr, @scopes.length - 1 - i)
        return
      end
    end
  end
end

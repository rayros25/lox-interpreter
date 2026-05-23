require "./lox"
require "./loxruntimeerror"
require "./loxcallable"
require "./loxfunction"
require "./environment"
require "./returnobj"
require "./loxclass"

class Interpreter
  ## PUBLIC ##

  attr_accessor :globals

  def initialize
    @globals = Environment::new
    @environment = @globals
    @locals = Hash::new

    # Slightly different from Java code
    clockclass =
    Class.new do
      # include LoxCallable
      def arity
        return 0
      end
      def call( interpreter, arguments )
        # TODO: Maybe round this a little
        return Time.now.to_f
      end
      def to_s
        return "<native fn>"
      end
    end

    @globals.define("clock", clockclass.new)
  end

  def interpret( statements )
    begin
      statements.each do |statement|
        execute statement
      end
    rescue LoxRuntimeError => error
      Lox::runtimeError( error )
    end
  end

  def visitLiteralExpr( expr )
    return expr.value
  end

  def visitLogicalExpr( expr )
    left = evaluate expr.left

    if expr.operator.type == :or
      return left if isTruthy left
    else
      return left if not isTruthy left
    end

    return evaluate expr.right
  end

  def visitMySetExpr( expr )
    object = evaluate expr.object

    unless object.is_a? LoxInstance
      raise LoxRuntimeError::new( epxr.name, "Only instances have fields." )
    end

    value = evaluate expr.value
    object.set( expr.name, value )
    return value
  end

  def visitGroupingExpr( expr )
    evaluate expr.expression
  end

  def visitUnaryExpr( expr )
    right = evaluate expr.right

    case expr.operator.type
    when :bang
      return !isTruthy(right)
    when :minus
      checkNumberOperand( expr.operator, right )
      return -right
    end
  end

  def visitVariableExpr( expr )
    return lookUpVariable( expr.name, expr )
  end

  def lookUpVariable( name, expr )
    distance = @locals[expr]
    if distance
      return @environment.getAt( distance, name.lexeme )
    else
      return @globals.get( name )
    end
  end

  def visitBinaryExpr( expr )
    left = evaluate expr.left
    right = evaluate expr.right

    case expr.operator.type
    when :greater
      checkNumberOperands( expr.operator, left, right )
      return left > right
    when :greater_equal
      checkNumberOperands( expr.operator, left, right )
      return left >= right
    when :less
      checkNumberOperands( expr.operator, left, right )
      return left < right
    when :less_equal
      checkNumberOperands( expr.operator, left, right )
      return left <= right

    # This is fine, right?
    when :equal_equal
      return left == right
    when :bang_equal
      return left != right

    when :minus
      checkNumberOperands( expr.operator, left, right )
      return left - right
    when :slash
      checkNumberOperands( expr.operator, left, right )
      return left / right
    when :star
      checkNumberOperands( expr.operator, left, right )
      return left * right
    when :plus
      if left.is_a? Float and right.is_a? Float
        return left + right
      end

      if left.is_a? String and right.is_a? String
        return left + right
      end

      raise LoxRuntimeError::new( expr.operator, "Operands must be two numbers or two strings." )
    end
  end

  def visitCallExpr( expr )
    callee = evaluate expr.callee

    arguments = []
    expr.arguments.each do |argument|
      arguments << evaluate( argument )
    end

    # NOTE: This implementation is slightly different from the Java one,
    # because Ruby doesn't have interfaces.
    unless callee.respond_to? :call
      raise LoxRuntimeError::new( expr.paren, "Can only call functions and classes." )
    end

    function = callee # TODO: LoxCallable cast?

    if arguments.length != function.arity
      raise LoxRuntimeError::new( expr. paren, "Expected #{function.arity} arguments but got #{arguments.length}." )
    end

    return function.call( self, arguments )
  end

  def visitGetExpr( expr )
    object = evaluate expr.object
    if object.is_a? LoxInstance
      return object.get(expr.name)
    end

    raise LoxRuntimeError::new( expr.name, "Only instances have properties." )
  end

  ## PRIVATE ##
  def isTruthy( object )
    return false if object.nil?
    return object if object.is_a? TrueClass or
                     object.is_a? FalseClass # This is so dumb.
    return true
  end

  def evaluate( expr )
    return expr.accept self
  end

  def execute( stmt )
    stmt.accept(self)
  end

  def resolve( expr, depth )
    @locals[expr] = depth
  end

  def executeBlock( statements, environment )
    previous = @environment
    begin
      @environment = environment
      
      statements.each do |statement| 
        execute statement
      end
    ensure
      @environment = previous
    end
  end

  def visitBlockStmt( stmt )
    executeBlock( stmt.statements, Environment::new( @environment ) )
    return nil
  end

  def visitMyClassStmt( stmt )
    @environment.define( stmt.name.lexeme, nil )

    methods = Hash.new
    stmt.methods.each do |method|
      function = LoxFunction::new( method, @environment )
      methods[method.name.lexeme] = function
    end
    klass = LoxClass::new( stmt.name.lexeme, methods )

    @environment.assign( stmt.name, klass )
    return nil
  end


  def visitExpressionStmt( stmt )
    evaluate stmt.expression
    return nil
  end

  def visitFunctionStmt( stmt )
    function = LoxFunction::new( stmt, @environment )
    @environment.define( stmt.name.lexeme, function )
    return nil
  end

  def visitIfStmt( stmt )
    if isTruthy( evaluate stmt.condition )
      execute stmt.thenBranch
    elsif stmt.elseBranch
      execute stmt.elseBranch
    end

    return nil
  end

  def visitPrintStmt( stmt )
    value = evaluate stmt.expression
    puts stringify( value )
    return nil
  end

  def visitReturnStmt( stmt )
    value = nil
    value = evaluate stmt.value if stmt.value

    raise ReturnObj::new( value )
  end

  def visitVarStmt( stmt )
    value = nil
    unless stmt.initializer.nil?
      value = evaluate stmt.initializer
    end

    @environment.define( stmt.name.lexeme, value )
    return nil
  end

  def visitWhileStmt( stmt )
    while isTruthy( evaluate stmt.condition )
      execute stmt.body
    end
    return nil
  end

  def visitAssignExpr( expr )
    value = evaluate expr.value

    distance = @locals[expr]
    if distance
      @environment.assignAt( distance, expr.name, value )
    else
      @globals.assign( expr.name, value )
    end

    return value
  end


  def stringify( object )
    return "nil" if object.nil?

    if object.is_a? Float
      text = object.to_s
      if text.end_with? ".0"
        text = text[0..-3]
      end
      return text
    end

    return object.to_s

  end

  def checkNumberOperand( operator, operand )
    return if operand.is_a? Float
    raise LoxRuntimeError::new( operator, "Operand must be a number." )
  end

  def checkNumberOperands( operator, left, right )
    return if left.is_a? Float and right.is_a? Float
    raise LoxRuntimeError::new( operator, "Operands must be numbers." )
  end
end

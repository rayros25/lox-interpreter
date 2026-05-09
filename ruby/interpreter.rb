require "./lox"
require "./loxruntimeerror"

class Interpreter
  ## PUBLIC ##
  def interpret( expr )
    begin
      value = evaluate expr
      puts stringify( value )
    rescue LoxRuntimeError => error
      Lox::runtimeError( error )
    end
  end

  def visitLiteralExpr( expr )
    return expr.value
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

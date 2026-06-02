require "./expr"
require "./token"

# TODO: interfaces aren't a thing in Ruby, but this is supposed to implement
# the Visitor thing
class AstPrinter
  ## PUBLIC ##
  def print( expr )
    return expr.accept(self)
  end

  def visitBinaryExpr( expr )
    return parenthesize( expr.operator.lexeme, expr.left, expr.right )
  end

  def visitGroupingExpr( expr )
    return parenthesize("group", expr.expression)
  end

  def visitLiteralExpr( expr )
    return "nil" if expr.value.nil?
    return expr.value.to_s
  end

  def visitUnaryExpr( expr ) 
    return parenthesize( expr.operator.lexeme, expr.right )
  end

  ## PRIVATE ##
  def parenthesize( name, *exprs )
    builder = "(" << name

    exprs.each { |expr|
      builder << " "
      builder << expr.accept(self)
    }

    builder << ")"
    return builder
  end
end

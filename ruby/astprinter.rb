require "./expr"
require "./token"

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
    # return builder
  end
end


# expression = Binary::new( :a, :b, :c )
# expression = Binary::new( [:a, :b, :c] ) # Is this baD?
# expression = Binary::new([  Literal::new([6]), Token::new( :minus, "-", nil, 1 ), Literal::new([7]) ])

## TESTING
# expression = Binary::new([
#   Unary::new([ Token::new( :minus, "-", nil, 1 ),
#               Literal::new([ 123 ]) ]),
#   Token::new( :star, "*", nil, 1 ),
#   Grouping::new([ Literal::new([ 45.67 ]) ])
# ])
#
# puts AstPrinter::new.print(expression)

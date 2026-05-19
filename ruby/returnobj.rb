# NOTE: This is just known as "Return" in the original sourcecode, since the
# Return subclass is Stmt.Return in Java.
class ReturnObj < RuntimeError
  attr_accessor :value
  def initialize( value )
    @value = value
  end
end

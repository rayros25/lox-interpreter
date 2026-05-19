module LoxCallable
  def call( interpreter, arguments ); end
  def arity; end

  # Technically this doesn't follow the book, but what can you do?
  def is_callable?
    return true
  end
end

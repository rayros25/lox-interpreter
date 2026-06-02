class NativeFn
  def to_s
    "<native fn>"
  end
end

class Yap < NativeFn
  # include LoxCallable # is this needed?
  def arity
    1
  end

  def call( interpreter, arguments )
    subj = arguments[0]
    unless subj.is_a? String
      raise LoxRuntimeError::new( subj, "Expect 'yap' to be given a string." )
    end
    return "YAP! " + arguments[0]
  end
end

class Read < NativeFn
  def arity
    0
  end

  def call( foo, bar )
    ans = STDIN.gets
    ans.chomp!
    return ans
  end
end

def loadcorefuncs
  @globals.define("yap", Yap.new)
  @globals.define("read", Read.new)
end

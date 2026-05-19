# NOTE: We have to name this LoxRuntimeError, because Ruby already has one
# of those.
class LoxRuntimeError < RuntimeError
  attr_reader :token, :message
  def initialize( token, message )
    super( message ) # TODO: Does this work?
    @message = message
    @token = token
  end

  def getMessage
    @message
  end
end

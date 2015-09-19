class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def ensure_token_valid
    token = Token.find_by(value: params['token'])
    if token.nil?
        render json: {error: "Token invalid"}
    else token.nil?
        @current_user = token.user
    end
  end
end

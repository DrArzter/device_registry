class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  private

  def authenticate_user!
    authenticate_with_http_token do |token, _options|
      api_key = ApiKey.includes(:bearer).find_by(token: token)
      @current_user = api_key&.bearer
    end

    head :unauthorized unless @current_user
  end
end
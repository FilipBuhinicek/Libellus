class ApplicationController < ActionController::API
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded_token = decode_token(token)
    @current_user = User.find(decoded_token["user_id"]) if decoded_token
  rescue JWT::DecodeError
    render json: { error: "Invalid or expired token" }, status: :unauthorized
  end

  attr_reader :current_user

  private

  def decode_token(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base).first
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def user_not_authorized(exception)
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end
end

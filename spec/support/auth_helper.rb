module AuthHelper
  def auth_headers_for(user)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end
end

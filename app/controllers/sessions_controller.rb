class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)

      AutoNotificationService.call(user) if user.member?

      render json: {
        token: token,
        user: UserSerializer.new(user).serializable_hash
        }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end

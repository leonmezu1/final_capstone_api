class ApplicationController < ActionController::API
  include JsonErrors

  def render_created_user(user)
    payload = { user_id: user.id }
    token = encode_token payload
    render json: {
      status: :created,
      logged_in: true,
      user: UserSerializer.new(user).serializable_hash,
      jwt: token
    }
  end

  private

  def encode_token(payload = {})
    exp = 24.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.token_encoder)
  end
end

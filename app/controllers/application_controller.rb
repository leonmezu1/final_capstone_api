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

  def log_in_successful(user)
    payload = { user_id: user.id }
    token = encode_token payload
    render json: {
      status: :created,
      logged_in: true,
      jwt: token
    }
  end

  # def render_logged_in_user
  #  render json: {
  #    logged_in: true,
  #    user: UserSerializer.new(@current_user).serializable_hash
  #  }
  # end

  def render_not_logged_in
    render json: {
      logged_in: false
    }
  end

  def render_logout_true
    render json: {
      status: 200,
      logged_out: true
    }
  end

  def render_status_not_found
    render json: { status: 401 }
  end

  private

  def encode_token(payload = {})
    exp = 24.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.token_encoder)
  end
end

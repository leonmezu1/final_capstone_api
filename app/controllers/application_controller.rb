class ApplicationController < ActionController::API
  include JsonErrors

  def auth_header_token
    request.headers['Authorization'].split[1]
  end

  def session_user
    pp decoded_token
    decoded_hash = decoded_token
    return if decoded_hash.empty?

    user_id = decoded_hash[0]['user_id']
    User.find_by(id: user_id)
  end

  def decoded_token
    return unless auth_header_token

    begin
      JWT.decode(
        auth_header_token,
        Rails.application.credentials.token_encoder,
        true,
        algorithm: 'HS256'
      )
    rescue JWT::DecodeError
      []
    end
  end

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

  def render_logged_in_user
    return unless session_user

    render json: {
      logged_in: true,
      user: UserSerializer.new(session_user).serializable_hash
    }
  end

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
    JWT.encode(
      payload,
      Rails.application.credentials.token_encoder
    )
  end
end

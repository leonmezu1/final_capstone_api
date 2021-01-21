class ApplicationController < ActionController::API
  include JsonErrors

  before_action :header_token_present?

  def auth_header_token
    return unless headers['Authorization']

    request.headers['Authorization'].split[1]
  end

  def session_user
    decoded_hash = decoded_token
    return if decoded_hash.empty?

    user_id = decoded_hash[0]['user_id']
    @current_user = User.find_by(id: user_id)
  end

  def decoded_token
    return unless auth_header_token

    JWT.decode(
      auth_header_token,
      Rails.application.credentials.token_encoder,
      true,
      algorithm: 'HS256'
    )
  rescue JWT::DecodeError
    []
  end

  def render_created_user(user)
    payload = { user_id: user.id }
    token = encode_token payload
    render json: {
      logged_in: true,
      user: UserSerializer.new(user).serializable_hash,
      jwt: token
    }, status: :created
  end

  def log_in_successful(user)
    payload = { user_id: user.id }
    token = encode_token payload
    render json: {
      logged_in: true,
      jwt: token
    }, status: :created
  end

  def render_logged_in_user
    return unless session_user

    render json: {
      logged_in: true,
      user: UserSerializer.new(session_user).serializable_hash
    }, status: :created
  end

  def render_not_logged_in
    render json: { logged_in: false }, status: :unauthorized
  end

  def render_status_not_found
    render json: { status: 401 }, status: 401
  end

  def header_token_present?
    render json: { error: 'Authentication token missing' }, status: :unauthorized unless auth_header_token
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

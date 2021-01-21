class SessionsController < ApplicationController
  def login
    user = fetch_user
    render_status_not_found unless user

    return unless user

    log_in_successful user
  end

  def auto_login
    render_logged_in_user if session_user
    render_not_logged_in unless session_user
  end

  private

  def sessions_params
    params.require(:user).permit(:email, :password)
  end

  def fetch_user
    User
      .find_by(email: sessions_params[:email])
      .try(:authenticate, sessions_params[:password])
  end
end

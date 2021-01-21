class TokensController < ApplicationController
  def create
    user = fetch_user

    render_status_not_found unless user

    return unless user

    log_in_successful user
  end

  private

  def token_params
    params.require(:user).permit(:email, :password)
  end

  def fetch_user
    User
      .find_by(email: token_params[:email])
      .try(:authenticate, token_params[:password])
  end
end

class RegistrationsController < ApplicationController
  def create
    user = User.create!(user_params)

    return unless user.valid?

    render_created_user user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

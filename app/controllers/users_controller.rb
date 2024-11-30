class UsersController < ApplicationController
  def update
    if @current_user.update(user_params)
      redirect_to root_path, notice: "Profile successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end

class Public::UsersController < ApplicationController
  
  def my_page
  end
  
  def edit
  end
  
  def update
    if current_user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to my_page_path
    else
      render :edit
    end
  end
  
  # ユーザ退会機能  
  def unsubscribe
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nick_name, :email, :profile_image)
  end
end

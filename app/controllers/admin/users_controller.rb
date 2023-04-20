class Admin::UsersController < ApplicationController
  
  def top
    @users = User.all
  end
  
  def information
    @user = User.find(params[:id])
  end
  
end

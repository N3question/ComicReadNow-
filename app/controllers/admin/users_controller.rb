class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def top
    @users = User.all
  end
  
  def information
    @user = User.find(params[:id])
    @comics = Comic.where(user_id: @user.id).order(updated_at: :desc)
    
    users = User.all.sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count}
  
    default = 1
    users.each do |user| 
      @my_rank = default # 13行目と＝じゃない。a
      break if user == @user # 特定のユーザになったらループをSTOP
      default += 1
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_information_path(@user.id)
    else
      render 'information'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:is_deleted) 
  end
  
end

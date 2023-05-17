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
  
end

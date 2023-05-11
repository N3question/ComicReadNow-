class Admin::UsersController < ApplicationController
  
  def top
    @users = User.all
  end
  
  def information
    @user = User.find(params[:id])
    
    users = User.all.sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count}
  
    default = 1 
    users.each do |user| 
      if @user.id
        @my_rank = default # 13行目と＝じゃない。
        default += 1 
      end
    end
  end
  
  def comment_index
  end
  
end

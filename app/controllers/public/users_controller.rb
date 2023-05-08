class Public::UsersController < ApplicationController
  
  def my_page
    session["url"] = nil
    session["search_keyword"] = nil
    @bookmarks = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title).first(10)
    @bookmark_amount = Bookmark.where(user_id: current_user.id).joins(:comic).all
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
  
  def rank_index
    @users = User.all.sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count * 2 <=> a.read_judgements.where(can_read: true).count + b.update_count * 2 }
  end
    
  
  private
  
  def user_params
    params.require(:user).permit(:nick_name, :email, :profile_image)
  end
end

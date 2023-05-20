class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def top
    @users = User.all
  end
  
  def information
    @user = User.find(params[:id])
    @comics = Comic.where(user_id: @user.id).order(updated_at: :desc)
    @read_judgements = ReadJudgement.where(user_id: @user.id).order(updated_at: :desc)
    @bookmarks = Bookmark.where(user_id: @user.id).order(updated_at: :desc)
    
    # 配列の初期化
    @display_bookmarks = []
    @bookmarks.each do |bookmark|
      count = Bookmark.where(comic_id: bookmark.comic_id).count
      @display_bookmarks.push({"id" => bookmark.comic.id, "title" => bookmark.comic.title, "author" => bookmark.comic.author, "count" => count})
    end
    
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
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:is_deleted) 
  end
  
  def comic_params
    params.require(:comic).permit(:isbn)
  end
  
end

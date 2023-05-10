class Public::BookmarksController < ApplicationController
  
  before_action :comic_params, except: [:bookmark_index]
  
  def create
    bookmark = Bookmark.create(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      )
  end
  
  def destroy
    bookmark = Bookmark.find_by(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      ).destroy
  end
  
  
  def bookmark_index
    session["search_keyword"] = nil
    @bookmarks = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title).page(params[:page]).per(30)
    @bookmark_amount = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title)
  end
  
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :comic_id, :isbn)
  end
  
  def comic_params
    @comic = Comic.find(params[:comic_id])
  end
  
  
end

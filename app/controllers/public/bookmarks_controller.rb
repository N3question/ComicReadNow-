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
  
  # def new
  #   bookmark = Bookmark.new(
  #     user_id: current_user.id,
  #     comic_id: params[:comic_id]
  #     )
      
  #   if bookmark.save!
  #     if session["search_keyword"].nil?
  #       redirect_to request.referer
  #     else
  #       redirect_to request.referer
  #     end
  #   end
    
  #   comic = Comic.find(params[:comic_id])
  # end
  
  # def destroy
  #   bookmark = Bookmark.find_by(
  #     user_id: current_user.id,
  #     comic_id: params[:comic_id]
  #     )
    
  #   if bookmark.present?
  #       bookmark.destroy!
  #       if session["search_keyword"].nil?
  #       redirect_to request.referer
  #       else
  #       redirect_to request.referer
  #       end
  #   end
    
  #   comic = Comic.find(params[:comic_id])
  # end
  
  # def index
  #   session["search_keyword"] = nil
  #   @bookmarks = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title).page(params[:page]).per(30)
  #   @bookmark_amount = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title)
  # end
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :comic_id, :isbn)
  end
  
  def comic_params
    @comic = Comic.find(params[:comic_id])
  end
  
  
end

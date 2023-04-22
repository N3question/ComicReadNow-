class Public::BookmarksController < ApplicationController
  
  def new
    bookmark = Bookmark.new(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      )
    comic = Comic.find(params[:comic_id])
      
    if bookmark.save!
      if session["search_keyword"].nil?
        # redirect_to top_comic_info_comics_path(isbn: comic['isbn'])
        redirect_to request.referer
      else
        # redirect_to comic_path(comic.id)
        redirect_to request.referer
      end
    end
  end
  
  def destroy
    bookmark = Bookmark.find_by(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      )
    comic = Comic.find(params[:comic_id])
    
    if bookmark.present?
        bookmark.destroy!
        if session["search_keyword"].nil?
        # redirect_to top_comic_info_comics_path(isbn: comic['isbn'])
        redirect_to request.referer
        else
        # redirect_to comic_path(comic.id)
        redirect_to request.referer
        end
    end
  end
  
  def index
    @bookmarks = Bookmark.where(user_id: current_user.id).joins(:comic).order(:title)
  end
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :comic_id, :isbn)
  end
  
end

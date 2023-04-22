class Public::BookmarksController < ApplicationController
  
  def new
    bookmark = Bookmark.new(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      )
    comic = Comic.find(params[:comic_id])
      
    if bookmark.save!
      if session["search_keyword"].nil?
        redirect_to top_comic_info_comics_path(isbn: comic['isbn'])
      # elsif 
        
      else
        redirect_to comic_path(comic.id)
      end
    end
  end
  
  # def destroy
  #   bookmark = Bookmark.find_by(
  #     user_id: current_user.id, comic_id
  #     comic_id: params[:comic_id]
  #     )
      
  #   if bookmark.present?
  #       bookmark.destroy
  #       redirect_to bookmark_comics_path
  #   else
  #       redirect_to bookmark_comics_path
  #   end
  # end
  
  def index
    @bookmarks = Bookmark.where(
      user_id: current_user.id,
      comic_id: params[:comic_id]
    )
  end
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :comic_id, :isbn)
  end
  
end

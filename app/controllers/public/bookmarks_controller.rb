class Public::BookmarksController < ApplicationController
  
  def create
    bookmark = Bookmark.new(
      user_id: current_user.id,
      comic_id: params[:comic_id],
      )
      
    if bookmark.save!
      redirect_to search_index_comics_path(keyword: session["search_keyword"])
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
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :isbn)
  end
  
end

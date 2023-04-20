class Public::BookmarksController < ApplicationController
  
  def create
    bookmark = Bookmark.new(
      user_id: current_user.id,
      comic_id: params[:comic_id]
      )
      
    if bookmark.save!
      redirect_to bookmark_comics_path
    end
  end
  
  def destroy
    @comic = RakutenWebService::Books::Book.search(size:9)
    bookmark = @comic.bookmarks.find_by(user_id: current_user)
    if bookmark.present?
        bookmark.destroy
        redirect_to search_index_comics_path
    else
        redirect_to search_index_comics_path
    end
  end
  
  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :isbn)
  end
  
end

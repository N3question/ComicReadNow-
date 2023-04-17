class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  def top
    @comic_list = []
    
    @comics = RakutenWebService::Books::Book.search(size: 9).sort_by {|v| v["reviewAverage"] }.reverse
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "-releaseDate").sort_by {|v| v["reviewAverage"] }.reverse
  end
  
  def search_index
    if params[:keyword]
      @rakuten_web_services = RakutenWebService::Books::Book.search(title: params[:keyword])
    else
      @rakuten_web_services = []
    end
  end
  
  def comic_site_index
  end
  
  def show
  end
  
  private
  
  def rakuten_book_params
    params.require(:rakuten_book).permit(:isbn, :title, :author, :image_url)
  end
  
  # def new_rakuten_book_params
  #   params.require(:rakuten_book).permit(:isbn, :title, :author, :image_url)
  # end
  
  # def sale_rakuten_book_params
  #   params.require(:rakuten_book).permit(:isbn, :title, :author, :image_url)
  # end
end

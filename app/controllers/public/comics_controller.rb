class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  # データが呼び出せるのはsearchメゾットのみなので、コントローラ内で指定して表示しておく
  def top
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount").sort_by {|v| v["reviewAverage"] }
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }
  end
  
  def search_index
    if params[:keyword]
      @rakuten_web_services = RakutenWebService::Books::Book.search(size: 9, title: params[:keyword], sort: "standard")
    else
      @rakuten_web_services = []
    end
  end
  
  def comic_site_index
  end
  
  def show
  end
  
  private
  
  # def rakuten_book_params
  #   params.require(:rakuten_book).permit(:isbn, :title, :author, :image_url)
  # end
end

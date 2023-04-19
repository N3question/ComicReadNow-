class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  # データが呼び出せるのはsearchメゾットのみなので、コントローラ内で指定して表示しておく
  def top
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount").sort_by {|v| v["reviewAverage"] }
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }
  end
  
  def top_comic_info
    @top_comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
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
  
  def new
    @comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @rakuten_book = Comic.new
    # @comic_site = ComicSite.new
    
    # session[:previous_url] = request.referer
  end
  
  def create
    rakuten_book_info = RakutenWebService::Books::Book.search(isbn: comic_params[:isbn]).first
    @rakuten_book = Comic.new(comic_params)
    
    
    # 以下に必要な内容を追加すると一緒に保存できる
    @rakuten_book.title = rakuten_book_info['title']
    @rakuten_book.author = rakuten_book_info['author']
    @rakuten_book.author_kana = rakuten_book_info['authorKana']
    @rakuten_book.publisher_name = rakuten_book_info['publisherName']
    @rakuten_book.sales_date = rakuten_book_info['salesDate'] #.gsub(/年|月/, '-').gsub(/日/, '')
    @rakuten_book.large_image_url = rakuten_book_info['largeImageUrl'].split('?')[0]
    
    
    rb_exists = Comic.find_by(isbn: comic_params[:isbn])

    if rb_exists.nil?
      @rakuten_book.save!
      site_params[:site_ids].each do |site_id|
        ComicSite.create(site_id: site_id.to_i, comic_id: @rakuten_book.id)
      end
      redirect_to comic_path(@rakuten_book)
    else
      redirect_to comic_path(rb_exists)
    end
    
  end
  
  def show
    @rakuten_book = Comic.find(params[:id])
  end
  
  private
  
  def comic_params
    # byebug
    params.require(:comic).permit(:isbn)
  end
  
  def site_params
    params.require(:comic).permit(site_ids: [])
  end
  
end

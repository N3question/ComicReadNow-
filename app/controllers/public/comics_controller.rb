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
    @comic_deta = RakutenBook.find_by(isbn: rakuten_book_params[:isbn])
  end
  
  def comic_site_index
  end
  
  def new
    @comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @rakuten_book = RakutenBook.new
    # session[:previous_url] = request.referer
  end
  
  def create
    rakuten_book_info = RakutenWebService::Books::Book.search(isbn: rakuten_book_params[:isbn]).first
    @rakuten_book = RakutenBook.new(rakuten_book_params)
    
    # 以下に必要な内容を追加すると一緒に保存できる
    @rakuten_book.title = rakuten_book_info['title']
    @rakuten_book.author = rakuten_book_info['author']
    @rakuten_book.author_kana = rakuten_book_info['authorKana']
    @rakuten_book.publisher_name = rakuten_book_info['publisherName']
    @rakuten_book.sales_date = rakuten_book_info['salesDate'].gsub(/年|月/, '-').gsub(/日/, '')
    @rakuten_book.large_image_url = rakuten_book_info['largeImageUrl'].split('?')[0]
    
    rb_exists = RakutenBook.find_by(isbn: rakuten_book_params[:isbn])
    
    if rb_exists.nil?
      @rakuten_book.save!
      redirect_to comic_path(@rakuten_book)
    else
      redirect_to comic_path(rb_exists)
    end
    
  end
  
  def show
    @rakuten_book = RakutenBook.find(params[:id])
  end
  
  private
  
  def rakuten_book_params
    params.require(:rakuten_book).permit(:isbn)
  end
  
end

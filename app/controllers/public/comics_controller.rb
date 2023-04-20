class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  # データが呼び出せるのはsearchメゾットのみなので、コントローラ内で指定して表示しておく
  def top
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount").sort_by {|v| v["reviewAverage"] }
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }
  end
  
  def top_rb_info
    @rb_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
  end
  
  def top_comic_info
  end 
  
  def search_index
    if params[:keyword]
      @rakuten_web_services = RakutenWebService::Books::Book.search(size: 9, title: params[:keyword], sort: "standard")
      session["search_keyword"] = params[:keyword]
    else
      @rakuten_web_services = []
    end
  end
  
  def comic_site_index
  end
  
  def new
    @comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @rb_comic_info = Comic.new
  end
  
  def create
    rakuten_book_info = RakutenWebService::Books::Book.search(isbn: comic_params[:isbn]).first
    @rb_comic_info = Comic.new(comic_params)
    
    
    # 以下の内容と一緒に保存
    @rb_comic_info.user_id = current_user.id
    @rb_comic_info.title = rakuten_book_info['title']
    @rb_comic_info.author = rakuten_book_info['author']
    @rb_comic_info.author_kana = rakuten_book_info['authorKana']
    @rb_comic_info.publisher_name = rakuten_book_info['publisherName']
    @rb_comic_info.sales_date = rakuten_book_info['salesDate'] #.gsub(/年|月/, '-').gsub(/日/, '')
    @rb_comic_info.large_image_url = rakuten_book_info['largeImageUrl'].split('?')[0] #.split('?')[0]をつけることで、元の画像サイズで表示
    
    
    rb_exists = Comic.find_by(isbn: comic_params[:isbn])

    if rb_exists.nil?
      # byebug
      @rb_comic_info.save!
      site_params[:site_ids].each do |site_id|
        ComicSite.create(site_id: site_id.to_i, comic_id: @rb_comic_info.id)
      end
      redirect_to comic_path(@rb_comic_info)
    else
      redirect_to comic_path(rb_exists)
    end
  end
  
  def show
    @rb_comic_info = Comic.find(params[:id])
  end
  
  private
  
  def comic_params
    params.require(:comic).permit(:isbn, :user_id)
  end
  
  def site_params
    params.require(:comic).permit(site_ids: [])
  end
  
  # 追加
  # def comic_site_params
  #   params.require(:comic_site).permit(:site_id,:comic_id)
  # end
end

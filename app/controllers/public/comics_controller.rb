class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  # データが呼び出せるのはsearchメゾットのみなので、コントローラ内で指定して表示しておく
  def top
    session["search_keyword"] = nil
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }.first(15)
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount").sort_by {|v| v["reviewAverage"] }.first(15)
    @bookmark_comics = Comic.find(Bookmark.joins(:comic).group(:comic_id).order('count(bookmarks.comic_id) DESC').order('comics.title ASC').pluck(:comic_id))
    @next_comics = @new_comics.select do |comic|
      begin
        # stringから日付を取り出しDateにする。それがDate.currentよりも大きい場合はtrue
        Date.current < Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        # エラーの場合はfalseで、selectは取得されず弾かれる
        false
      end
    end
    @now_comics = RakutenBookApi.select do |comic|
      begin
        # stringから日付を取り出しDateにする。それがDate.currentよりも小さい場合はtrue
        Date.current > Date.parse(comic.sales_date.gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        # エラーの場合はfalseで、selectは取得されず弾かれる
        false
      end
    end
  end
  
  def top_comic_info
    @top_comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
  end
  
  def sale_index
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }
  end
  
  def review_count_index
    page = 1
    if params[:page].present?
      page = params[:page].to_i
    end
    @prev = page - 1
    if page <= 1
      page = 1
      @prev = 1
    end
    @next = page + 1
    if page > 10
      page = 10
      @next = 10
    end
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount", page: page).sort_by {|v| v["reviewAverage"] }
  end
  
  def search_index
    if params[:keyword]
      @rakuten_web_services = RakutenWebService::Books::Book.search(size: 9, title: params[:keyword], sort: "standard")
      session["search_keyword"] = params[:keyword]
    else
      @rakuten_web_services = []
    end
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
    if !request.referer&.include?("/comics") || 
      request.referer&.include?("/sale_index") || 
      request.referer&.include?("/review_count_index") || 
      request.referer&.include?("/search_index") ||
      request.referer&.include?("/comic_site_index") 
      
      session["url"] = request.referer
    end
    @rb_comic_info = Comic.find(params[:id])
  end
  
  def comic_site_index
    @comic_site = ComicSite.find_by(site_id: params[:id])
    @comic_sites = ComicSite.where(site_id: params[:id]).joins(:comic).order(:title)
    @comic_site_amount = ComicSite.where(site_id: params[:id]).joins(:comic).all
  end
  
  private
  
  def comic_params
    params.require(:comic).permit(:isbn, :user_id)
  end
  
  def site_params
    params.require(:comic).permit(site_ids: [])
  end
  
end

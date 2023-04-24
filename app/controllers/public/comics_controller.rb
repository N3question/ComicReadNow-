class Public::ComicsController < ApplicationController
  
  # 楽天APIから直接呼び出して表示させる
  # データが呼び出せるのはsearchメゾットのみなので、コントローラ内で指定して表示しておく
  def top
    session["search_keyword"] = nil
    
    @new_comics = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }.first(15)
    @comics = RakutenWebService::Books::Book.search(size: 9, sort: "reviewCount").sort_by {|v| v["reviewAverage"] }.first(15)
    @bookmark_comics = Comic.find(
                        Bookmark.joins(:comic)
                        .group(:comic_id)
                        .order('count(bookmarks.comic_id) DESC')
                        .order('comics.title ASC')
                        .pluck(:comic_id)
                        ).first(15)
    @new_comics_all = RakutenWebService::Books::Book.search(size: 9, sort: "sales").sort_by {|v| v["-releaseDate"] }
    @next_comics = @new_comics_all.select do |comic|
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
    @top_rb_comic_info = Comic.find_by(isbn: params[:isbn])
  end
  
  def sale_index
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
    page = 1
    if params[:keyword]
      session["search_keyword"] = params[:keyword]
    end
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
    if session["search_keyword"]
      @rakuten_web_services = RakutenWebService::Books::Book.search(size: 9, title: session["search_keyword"], sort: "standard", page: page)
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
        ComicSite.create(
          site_id: site_id.to_i,
          comic_id: @rb_comic_info.id
          )
      end
      redirect_to comic_path(@rb_comic_info)
      # redirect_to request.referer
    else
      redirect_to comic_path(rb_exists)
      # redirect_to request.referer
    end
  end
  
  def show
    if !request.referer&.include?("/comics") || 
      request.referer&.include?("/sale_index") || 
      request.referer&.include?("/review_count_index") || 
      request.referer&.include?("/search_index") ||
      request.referer&.include?("/comic_site_index") ||
      request.referer&.include?("/next_coming_index") ||
      request.referer&.include?("/user_select_index") 
      
      session["url"] = request.referer
    end
    @rb_comic_info = Comic.find(params[:id])
    @create_user = User.find(@rb_comic_info.user_id)
    @create_sites = @rb_comic_info.sites.all
    @can_read = TotalReadableInfo.where(
        comic_id: @rb_comic_info.id,
        can_read: true
        ).count
    @can_not_read = TotalReadableInfo.where(
        comic_id: @rb_comic_info.id,
        can_read: false
        ).count
    @user_read_judgement = TotalReadableInfo.find_by(
      comic_id: @rb_comic_info.id,
      user_id: current_user.id
      )
    @has_bookmark = Bookmark.find_by(
      comic_id: @rb_comic_info.id,
      user_id: current_user.id
      )
  end
  
  def comic_site_index
    @comic_site = ComicSite.find_by(site_id: params[:id])
    @comic_sites = ComicSite.where(site_id: params[:id]).joins(:comic).order(:title)
    @comic_site_amount = ComicSite.where(site_id: params[:id]).joins(:comic).all
  end
  
  def user_select_index
    comic_ids = Bookmark.joins(:comic)
                        .group(:comic_id)
                        .order('count(bookmarks.comic_id) DESC')
                        .order('comics.title ASC')
                        .pluck(:comic_id)
    @bookmark_comics = Comic.where(id: comic_ids).page(params[:page]).per(30)
  end
  
  def edit
    comic_info = Comic.find(params[:id])
    
    # 特定のユーザが押した「読めた」または「読めなかった」のデータをTotalReadableInfoから探す
    user_comic_info = TotalReadableInfo.find_by(user_id: current_user, comic_id: comic_info.id)
    
    # 後でviewにもifを定義する
    # ユーザのupdateのlimit(漫画全体)が1以下 |または| ユーザのupdateのlimit(漫画単体)が1以下
    if current_user.remaining_total_update_limit < 1 || user_comic_info.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    # 特定のユーザが押した「読めた」または「読めなかった」のデータ && ユーザのupdateのlimit(漫画単体)が1以下
    elsif user_comic_info && user_comic_info.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    end
    
    @comic_info_edit = Comic.find(params[:id])
  end
  
  def update
    comic_info = Comic.find(params[:id])
    
    # （！）特定のユーザが（漫画単体に対して）押した「読めた」または「読めなかった」のデータをTotalReadableInfoから探す
    user_comic_info = TotalReadableInfo.find_by(user_id: current_user, comic_id: comic_info.id)
    
    # ユーザのupdateのlimit(漫画全体)が1以下 |または| ユーザのupdateのlimit(漫画単体)が1以下
    if current_user.remaining_total_update_limit < 1 || user_comic_info.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    # （！） && ユーザのupdateのlimit(漫画単体)が1以下
    elsif user_comic_info && user_comic_info.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    end
    
    # limit = user_comic_info.remaining_one_comic_update_limit # 追加
    
    # 漫画情報更新
    comic_info.update(update_params.merge({
        # 更新時に行う動作
        can_read_count: 0,  
        can_not_read_count: 0, 
        version: comic_info.version + 1,
        # remaining_one_comic_update_limit: limit - 1
        }))
        
    total_limit = current_user.remaining_total_update_limit
    
    # 同時にユーザの更新
    current_user.update!(
        remaining_total_update_limit: total_limit - 1
        )
    redirect_to comic_path(comic_info.id)  
  end
  
  def read_judgement
    comic = Comic.find(params[:comic_id])
    
    version = comic.version
    @total_readable_info = comic.total_readable_infos.new({
        can_read: params[:read_info],
        version: version, 
        user_id: current_user.id
        })
    
    @total_readable_info.save
    # render :partial => 'total'
    redirect_to comic_path(comic.id)
  end
  
  # View＝＞
  # comicの詳細ページで一回押したら押せないようにする。submitを非表示
  # 件数表示はいいねと同じ
  
  private
  
  def comic_params
    params.require(:comic).permit(:isbn, :user_id)
  end
  
  def update_params
    params.require(:comic).permit(:user_id)
  end
  
  def site_params
    params.require(:comic).permit(site_ids: [])
  end
end

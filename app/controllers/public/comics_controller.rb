class Public::ComicsController < ApplicationController
  
  ## TOP
  def top
    session["url"] = nil
    session["search_keyword"] = nil
    
    
    ### 新着
    comics =  RakutenBookApi.select do |comic|
      begin
        Date.current > Date.parse(comic.sales_date.gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    @new_comics = comics.first(15) #追加
    
    
    ### User Select
    @bookmark_comics = Comic.find(
          Bookmark.joins(:comic)
          .group(:comic_id)
          .order('count(bookmarks.comic_id) DESC')
          .order('comics.title ASC')
          .pluck(:comic_id)
          ).first(15)
    
    
    ### 総合ランキング
    @review_comics = RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "reviewCount"
          )
          .sort_by {|v| v["reviewAverage"] }
          .first(15)
          
          
    ## #Next Coming
    @next_comics = RakutenBookApi.select do |comic|
      begin
        Date.current < Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
  end
  
  
  
  
  ## TOP / 漫画情報詳細
  def top_comic_info
    @top_rb_comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @top_comic_info = Comic.find_by(isbn: params[:isbn])
  end
  
  
  
  
  
  ## 新着一覧
  def sale_index
    @now_comics = RakutenBookApi.select do |comic|
      begin
        Date.current > Date.parse(comic.sales_date.gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    @now_comics_page = Kaminari.paginate_array(@now_comics).page(params[:page]).per(30)
  end
  
  ## User Select一覧
  def user_select_index
    comic_ids = Bookmark.joins(:comic)
                        .group(:comic_id)
                        .order('count(bookmarks.comic_id) DESC')
                        .order('comics.title ASC')
                        .pluck(:comic_id)
    @bookmark_comics = Comic.where(id: comic_ids).page(params[:page]).per(30)
  end
  
  
  
  
  
  ## 総合ランキング一覧
  def review_count_index
    page = 1
    
    # ページネーション
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
    
    # 表示内容
    @comics = RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "reviewCount", 
          page: page
          ).sort_by {|v| v["reviewAverage"] }
  end
  
  
  
  
  
  
  ## 検索結果一覧
  def search_index
    page = 1
    
    ## 前提
      # :keywordのparamsの有無を確認 && :pageの存在も確認
      # その場合、sessionに:keywordが保持される＋paramsの数字を正数にする（？）
    if params[:keyword] && params[:page].present?
      session["search_keyword"] = params[:keyword] 
      page = params[:page].to_i
    # :keywordのparamsの有無を確認 
    # その場合、sessionに:keywordが保持される
    elsif params[:keyword]
      session["search_keyword"] = params[:keyword]
    end
    
    # 最終結果(pageに入る値が決定）
    @current_page = page
    
    # pageを前後に遷移させるための実装
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
    
    # 楽天APIを直接search
    if session["search_keyword"]
      @rakuten_web_services = RakutenWebService::Books::Book.search(
            size: 9, 
            title: session["search_keyword"], 
            sort: "standard", 
            page: page
            )
    else
      @rakuten_web_services = []
    end
  end
  
  
  
  
   ## サイト毎の一覧
  def comic_site_index
    @comic_site = ComicSite.find_by(site_id: params[:id])
    @comic_sites = ComicSite.where(site_id: params[:id]).joins(:comic).order(:title)
    @comic_site_amount = ComicSite.where(site_id: params[:id]).joins(:comic).all
  end
  
  
  
  
  
  ## サイト情報新規作成(new)
  def new
    @rb_comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @comic = Comic.new
  end
  
  
  
  
  
  ## サイト情報新規作成(create))
  def create
    rakuten_book_info = RakutenWebService::Books::Book.search(isbn: comic_params[:isbn]).first
    @comic = Comic.new(comic_params)
    
    # 以下の内容と一緒に保存
    @comic.user_id = current_user.id
    @comic.title = rakuten_book_info['title']
    @comic.author = rakuten_book_info['author']
    @comic.author_kana = rakuten_book_info['authorKana']
    @comic.publisher_name = rakuten_book_info['publisherName']
    @comic.sales_date = rakuten_book_info['salesDate']
    @comic.large_image_url = rakuten_book_info['largeImageUrl'].split('?')[0] #元の画像サイズで保存
    
    # コミックが既に存在していた場合、リダイレクト
    comic_exists = Comic.find_by(isbn: comic_params[:isbn])
    if comic_exists.nil?
      @comic.save!
      site_params[:site_ids].each do |site_id|
        ComicSite.create(
          site_id: site_id.to_i,
          comic_id: @comic.id
          )
      end
      redirect_to comic_path(@comic)
    else
      redirect_to comic_path(comic_exists)
    end
  end
  
  
  
  
  
  ## 漫画情報詳細
  def show
    if !request.referer&.include?("/comics") || 
      request.referer&.include?("/sale_index/#{params[:current_page]}")|| 
      request.referer&.include?("/review_count_index") || 
      request.referer&.include?("/comic_site_index/#{params[:site_id]}") ||
      request.referer&.include?("/next_coming_index") ||
      request.referer&.include?("/user_select_index") ||
      request.referer&.include?("/my_page") ||
      request.referer&.include?("/bookmarks") 
      
      session["url"] = request.referer
    end
    
    @comic = Comic.find(params[:id])
    @sites = @comic.sites.all
    @can_read = ReadJudgement.where(
                  comic_id: @comic.id,
                  can_read: true # = 読めた
                  )
    @can_not_read = ReadJudgement.where(
                      comic_id: @comic.id,
                      can_read: false # = 読め
                      )
    @comic_update_limit_count = @comic.remaining_one_comic_update_limit
  end
  
  
  
  
  
  
  ## サイト情報の編集
  def edit
    @comic = Comic.find(params[:id])
    user_can_read_info = ReadJudgement.find_by(
                          user_id: current_user, 
                          comic_id: @comic.id
                          )
    
    # ユーザのupdateのlimit(漫画全体)が1以下 |または| ユーザのupdateのlimit(漫画単体)が1以下
    if current_user.remaining_total_update_limit < 1 || @comic.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    # （！） && ユーザのupdateのlimit(漫画単体)が1以下
    elsif user_can_read_info && @comic.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    end
  end
  
  
  
  
  
  ## サイト情報の更新
  def update
    comic = Comic.find(params[:id])
    user_can_read_info = ReadJudgement.find_by(
                          user_id: current_user.id, 
                          comic_id: comic.id
                          )
    
    # ユーザのupdateのlimit(漫画全体)が1以下 |または| ユーザのupdateのlimit(漫画単体)が1以下
    if current_user.remaining_total_update_limit < 1 || comic.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    # （！） && ユーザのupdateのlimit(漫画単体)が1以下
    elsif user_can_read_info && comic.remaining_one_comic_update_limit < 1
        redirect_to request.referer
    end
    
    limit = comic.remaining_one_comic_update_limit # 追加
    
    # 漫画情報と編集者の更新
    comic.update(update_params.merge({
        # 更新時に行う動作
        can_read_count: 0, # 更新と同時に0になってない
        can_not_read_count: 0,
        version: comic.version + 1,
        remaining_one_comic_update_limit: limit - 1,
        user_id: current_user.id
        }))
        
    # 同時に漫画に紐づくサイト情報を一度削除し、作成
    comic.comic_sites.destroy_all
    site_params[:site_ids].each do |site_ids|
      ComicSite.create(
        site_id: site_ids.to_i,
        comic_id: comic.id
        )
    end
    
    total_limit = current_user.remaining_total_update_limit
    
    # 同時にユーザの更新回数を１減らす
    current_user.update(
        remaining_total_update_limit: total_limit - 1
        )
    redirect_to comic_path(comic.id)  
  end
  
  
  
  
  
  ## create - 可読判定
  def read_judgement
    comic = Comic.find(params[:comic_id])
    
    version = comic.version
    if params[:read_info]
      comic.can_read_count =+ 1
    else
      comic.can_not_read_count =+ 1
    end

    @total_readable_info = comic.total_readable_infos.new({
        can_read: params[:read_info],
        version: version, 
        user_id: current_user.id
        })
    
    comic.save
    @total_readable_info.save
    redirect_to comic_path(comic.id)
  end
  
  
  
  
  
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

# comic2に対してのversion0のときのtrueの数をカウントできる。
# TotalReadableInfo.where(comic_id: 2,version:0,can_read:true).count
# これをversion毎にユーザと紐付ける
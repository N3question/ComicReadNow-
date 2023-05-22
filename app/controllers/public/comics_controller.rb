class Public::ComicsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :read_judgement]
  
  ## TOP
  def top
    session["referer_url"] = nil
    session["search_keyword"] = nil
    
    ### User Ranking
    user_rank = User.where(is_deleted: false).sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count }
    @user_rank = user_rank.first(5)
    
    ### MY Ranking
    @users = User.where(is_deleted: false).sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count}
    
    default = 1 
    @users.each do |user| 
      if user_signed_in? && user.id == current_user.id
        @my_rank = default
      end
      default += 1 
    end
    
    
    
    
    ### 新着
    rb= RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "sales"
          )
          .sort_by {|v| v["-releaseDate"] }
    comic =  rb.select do |comic|
      begin
        Date.current > Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    @new_comics = comic.first(15) #追加
    
    
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
          
          
    ### Next Coming
    rb= RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "sales"
          )
          .sort_by {|v| v["-releaseDate"] }
    comics = rb.select do |comic|
      begin
        Date.current < Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    
    @next_comics = comics.first(15)
  end
  
  
  
  
  ## TOP / 漫画情報詳細
  # [TODO] top_comic_infoとshowを統合して詳細画面を１つにする
  def top_comic_info
    if !request.referer &.include?("/comics/#{params[:comic_id]}") || 
      !request.referer &.include?("/comics") ||
      !request.referer &.include?("/top_comic_info") || 
      request.referer&.include?("/sale_index/#{params[:current_page]}") || 
      request.referer&.include?("/review_count_index") || 
      request.referer&.include?("/comic_site_index/#{params[:site_id]}") ||
      request.referer&.include?("/next_coming_index") ||
      request.referer&.include?("/user_select_index") ||
      request.referer&.include?("/my_page") ||
      request.referer&.include?("/bookmarks") 
      
      session["referer_url"] = request.referer
    end
    
    @from_rws = params[:from_rws]
    @isbn = params[:isbn]
    @can_not_create_record = params[:can_not_create_record]
    
    @top_rb_comic_info = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    
    # [TODO] showと共通化を検討
    # [TODO] 命名もイメージがつきやすい名前にする
    @top_comic_info = Comic.find_by(isbn: params[:isbn])
    
    @comic = Comic.new
  end
  
  
  
  
  
  ## 漫画サイト情報新規作成(create))
  def create
    @comic = Comic.new(comic_params)
    rakuten_book_info = RakutenWebService::Books::Book.search(isbn: comic_params[:isbn]).first
    
    # 以下の内容と一緒に保存
    @comic.user_id = current_user.id
    @comic.title = rakuten_book_info['title']
    @comic.author = rakuten_book_info['author']
    @comic.author_kana = rakuten_book_info['authorKana']
    @comic.publisher_name = rakuten_book_info['publisherName']
    @comic.sales_date = rakuten_book_info['salesDate']
    @comic.large_image_url = rakuten_book_info['largeImageUrl'].split('?')[0] #元の画像サイズで保存
    
    
    comic_exists = Comic.find_by(isbn: comic_params[:isbn])
    if comic_exists.nil? # Comicのレコードがない場合
      @comic.save!
      
      # 漫画サイト情報を新規作成
      site_params[:site_ids].each do |site_id|
        ComicSite.create(
          site_id: site_id.to_i,
          comic_id: @comic.id
          )
      end
      
      # ログインユーザのupdate回数を＋2
      update_amount = current_user.update_count
      current_user.update(
        update_count: update_amount + 2
        )
        
      redirect_to comic_path(@comic)
    
    else # Comicのレコードが存在する場合
      redirect_to comic_path(comic_exists)
    end
  end

  
  
  
  
  ## 漫画情報詳細
  def show
    if !request.referer &.include?("/comics/#{params[:comic_id]}") || 
      !request.referer &.include?("/comics") ||
      !request.referer &.include?("/top_comic_info") || 
      request.referer&.include?("/sale_index/#{params[:current_page]}") || 
      request.referer&.include?("/search_index") ||
      request.referer&.include?("/review_count_index") || 
      request.referer&.include?("/comic_site_index/#{params[:site_id]}") ||
      request.referer&.include?("/next_coming_index") ||
      request.referer&.include?("/user_select_index") ||
      request.referer&.include?("/my_page") ||
      request.referer&.include?("/bookmarks") 
      
      session["referer_url"] = request.referer
    end
    
    # [TODO] top_comic_infoと共通化を検討
    @comic = Comic.find(params[:id])
    
    
    @rb_comic = RakutenWebService::Books::Book.search(isbn: @comic.isbn).first
    @sites = @comic.sites.all
    @can_read = ReadJudgement.where(
                  comic_id: @comic.id,
                  can_read: true, # 読めた
                  version: @comic.version
                  )
    @can_not_read = ReadJudgement.where(
                  comic_id: @comic.id,
                  can_read: false, # 読めなかった
                  version: @comic.version
                  )
    @comic_update_limit_count = @comic.remaining_one_comic_update_limit
    
    if user_signed_in?
      @user_read_judgement = ReadJudgement.find_by(
                    comic_id: @comic.id, 
                    user_id: current_user.id, 
                    version: @comic.version
                    )
    end
  end
  
  
  
  
  
  
  ## サイト情報の更新
  def update
    
    @comic = Comic.find(params[:id])
    
    # 前提条件
    before_comic_info = ComicSite.where(comic_id: @comic.id).pluck(:site_id)  # 今現在保存されているデータ
    after_comic_info = site_params[:site_ids]                                # これから更新するデータ
    
    # 配列の比較
    # uniq...[配列] 重複した要素を取り除いた新しい配列を返すメゾット
    # map...各要素へ順に処理を実行してくれるメソッド
    # [戻り値] 各要素の変更後の値が入った配列
    @success_flag = true
    if before_comic_info.uniq == after_comic_info.map(&:to_i)  # == (&:to_i.to_proc)
      @success_flag = false
      return # 早期リターン
    end
    # ここまで
    
    user_can_read_info = ReadJudgement.find_by(
                          user_id: current_user.id, 
                          comic_id: @comic.id
                          )
                          

    limit = @comic.remaining_one_comic_update_limit
    
    
    # 漫画情報と編集者の更新
    @comic.update(update_params.merge({
        # 更新時に行う動作
        can_read_count: 0,
        can_not_read_count: 0,
        version: @comic.version + 1,
        remaining_one_comic_update_limit: limit - 1,
        user_id: current_user.id
        }))
    
        
    # 同時に漫画に紐づくサイト情報を一度削除し、作成
    # 今後の実装ではDBに問い合わせ４回=>１回にしていくことを視野にしていく。
    @comic.comic_sites.destroy_all
    site_params[:site_ids].each do |site_ids|
      ComicSite.create(
        site_id: site_ids.to_i,
        comic_id: @comic.id
        )
    end
    
    total_limit = current_user.remaining_total_update_limit
    update_amount = current_user.update_count
    
    # 同時にユーザの更新残数を１減らす
    current_user.update(
        remaining_total_update_limit: total_limit - 1,
        update_count: update_amount + 1
        )
    # redirect_to comic_path(comic.id)  
    @can_not_read = ReadJudgement.where(
                  comic_id: @comic.id,
                  can_read: false, # 読めなかった
                  version: @comic.version
                  )
    @comic_update_limit_count = @comic.remaining_one_comic_update_limit
    @sites = @comic.sites.all
  end
  
  
  
  
  ## 可読判定(create)
  def read_judgement
    @comic = Comic.find(params[:comic_id])
    version = @comic.version
     # [TODO] showと共通化を検討
    # [TODO] 命名もイメージがつきやすい名前にする
    @top_comic_info = Comic.find(params[:comic_id])
    
    if params[:read_info] == "true"
      @comic.update(can_read_count: @comic.can_read_count + 1)
    else
      @comic.update(can_not_read_count: @comic.can_not_read_count + 1)
    end
    
    readable_info = @comic.read_judgements.new({
                        can_read: params[:read_info],
                        version: version, 
                        user_id: current_user.id
                        })
                        
    # binding.pry
    readable_info.save!
    
    @user_read_judgement = ReadJudgement.find_by(
              comic_id: @comic.id, 
              user_id: current_user.id, 
              version: version
              )
    @can_read = ReadJudgement.where(
              comic_id: @comic.id,
              can_read: true, # 読めた
              version: version
              )
    @can_not_read = ReadJudgement.where(
              comic_id: @comic.id,
              can_read: false, # 読めなかった
              version: version
              )
  
  end
  
  
  
  
  
  ## 新着一覧
  def sale_index
    if params[:page].nil?
      page = 1
    else
      page = params[:page].to_i
    end

    now_comics = RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "sales",
          page: page
          ).sort_by {|v| v["-releaseDate"] }
    
    
    now_comics = now_comics.select do |comic|
      begin
        Date.current > Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    
    # 次のページの漫画の数が0だった場合pageを+!
    if now_comics.count == 0
      redirect_to sale_index_comics_path(page: page + 1)
    end 
    
    @now_comics = Kaminari.paginate_array(
         now_comics, 
         total_count: 1200
         )
         .page(params[:page])
         .per(30)
    @comic = Comic.new
  end
  
  
  
  
  
  ## User Select一覧
  def user_select_index
    bookmark_comics = Comic.find(
          Bookmark.joins(:comic)
          .group(:comic_id)
          .order('count(bookmarks.comic_id) DESC')
          .order('comics.title ASC')
          .pluck(:comic_id)
          )
    @bookmark_comics = Kaminari.paginate_array(bookmark_comics).page(params[:page]).per(30)
  end
  
  
  
  
  
  
  ## 総合ランキング一覧
  def review_count_index
    # 前提
    if params[:page].nil?
      page = 1
    else
      page = params[:page].to_i
    end
    
    # 表示内容
    comics = RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "reviewCount",
          page: page
          ).sort_by {|v| v["reviewAverage"] }
          
    @comics = Kaminari.paginate_array(
          comics, 
          total_count: 1200
          )
          .page(params[:page])
          .per(30)
    @comic = Comic.new
  end
  
  
  
  
  
  
  ## Next Coming一覧
  def next_coming_index
    if params[:page].nil?
      page = 1
    else
      page = params[:page].to_i
    end
    
    next_comics = RakutenWebService::Books::Book.search(
          size: 9, 
          sort: "sales",
          page: page
          )
          .sort_by {|v| v["-releaseDate"] }
    next_comics = next_comics.select do |comic|
      begin
        Date.current < Date.parse(comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
      rescue => error
        false
      end
    end
    
    @next_comics = Kaminari.paginate_array(
          next_comics, 
          total_count: 1200
          )
          .page(params[:page])
          .per(30)
  end
  
  
  
  
  
  ## 検索結果一覧
  def search_index
    session["url"] = nil
    session["update_url"] = nil
    
    # ## 前提
    if params[:keyword] #&& params[:page].present?
      session["search_keyword"] = params[:keyword] 
    end
    
    if params[:page].nil?
      page = 1
    else
      page = params[:page].to_i
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
    
    view_count = 30
    @rakuten_web_services = Kaminari.paginate_array(
          @rakuten_web_services.first(view_count), 
          total_count: @rakuten_web_services
          .response["count"]
          )
          .page(params[:page])
          .per(view_count)
     
    @comic = Comic.new
  end
  
  
  
  
   ## サイト毎の一覧
  def comic_site_index
    session["url"] = nil
    session["update_url"] = nil
    session["search_keyword"] = nil
    
    @comic_site = ComicSite.find_by(
          site_id: params[:id]
          )
    @comic_sites = ComicSite.where(
          site_id: params[:id]
          )
          .page(params[:page])
          .per(30)
          .order(:title)
    @comic_site_amount = ComicSite.where(
          site_id: params[:id]
          )
          .joins(:comic).all
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
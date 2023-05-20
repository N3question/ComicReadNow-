module Public::ComicsHelper
    
  def before_date(rb_comic)
      Date.current > Date.parse(@top_rb_comic_info["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
  end
  
  def future_date(rb_comic)
      Date.current < Date.parse(@top_rb_comic_info["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
  end
  
  def user_upadte_limit_count(comic)
      current_user.remaining_total_update_limit
  end
  
  def comic_update_limit_count(comic)
      @comic.remaining_one_comic_update_limit
  end
  
  def sites(comic)
      @comic.sites.all
  end
  
  def can_read(comic)
      ReadJudgement.where(comic_id: @comic.id, can_read: true, version: @comic.version)
  end
  
  def can_not_read(comic)
      ReadJudgement.where(comic_id: @comic.id, can_read: false, version: @comic.version)
  end
  
  def user_read_judgement(comic)
      ReadJudgement.find_by(comic_id: @comic.id, user_id: current_user.id, version: @comic.version)
  end
  
  def current_version(comic)
      Comic.order(version: :desc).limit(1)
  end
  
end
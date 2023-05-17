module Public::ComicsHelper
    
  def before_date(top_rb_comic_info)
      Date.current > Date.parse(top_rb_comic_info["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
    # Viewに書いている定義をここに書く 
  end
  
end

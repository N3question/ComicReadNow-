module Public::ComicsHelper
    
  def before_date(rb_comic)
      Date.current > Date.parse(rb_comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
  end
  
  def future_date(rb_comic)
      Date.current < Date.parse(rb_comic["salesDate"].gsub("年", "/").gsub("月", "/").split("日")[0])
  end
  
end
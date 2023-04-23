# 以下の内容でそれぞれの順番ごとにDBに保存が完了
# 定期的にDBを更新させる定義はしていないので、自分がターミナルで都度たたかない限りは古いデータのまま
namespace :rakuten_book do
    
    # 売れてる順
    desc 'Insert sale book' # desc内容説明部分
    task insert: :environment do
        RakutenWebService.configure do |c|
          c.application_id = '1071710090605642106'
          c.affiliate_id = '3178901f.7ca7745a.31789020.b737c277'
      end
      (1..30).each do |num|
          RakutenWebService::Books::Book.search({
          booksGenreId: '001001',
          page: num,
          sort: "sales"
          }).each do |book|
            
            # 指定した内容のデータをDBに保存（作成）
            # 手動でデータを保存する内容になっている
            RakutenBookApi.find_or_create_by!(
                isbn: book["isbn"], 
                title: book["title"], 
                large_image_url: book["largeImageUrl"],
                sales_date: book["salesDate"]
                )
          end
        end
    end
end

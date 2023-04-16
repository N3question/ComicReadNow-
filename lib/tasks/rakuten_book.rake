namespace :rakuten_book do
     
    desc 'Insert book'
    task insert: :environment do
        RakutenWebService.configure do |c|
           c.application_id = '1071710090605642106'
           c.affiliate_id = '3178901f.7ca7745a.31789020.b737c277'
       end
       (1..35).each do |num|
          RakutenWebService::Books::Book.search({
          booksGenreId: '001001',
          page: num,
          sort: "sales"
          }).each do |book|
            
            RakutenBook.create!(author: book["author"], title: book["title"], isbn: book["isbn"], image_url: book["mediumImageUrl"])
          end
        end
    end
    
    
    desc 'Insert new book'
    task new_book_insert: :environment do
        RakutenWebService.configure do |c|
           c.application_id = '1071710090605642106'
           c.affiliate_id = '3178901f.7ca7745a.31789020.b737c277'
       end
       (1..2).each do |num|
          RakutenWebService::Books::Book.search({
          booksGenreId: '001001',
          typ
          page: num,
          sort: "sales"
          }).each do |book|
            
            NewRakutenBook.create!(author: book["author"], title: book["title"], isbn: book["isbn"], image_url: book["mediumImageUrl"])
          end
        end
    end
end

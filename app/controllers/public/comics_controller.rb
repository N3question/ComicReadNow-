class Public::ComicsController < ApplicationController
  
  def top
    @comics = []
    
    @comic_title = params[:title]
    if @title.present?
      results = RakutenWebService::Books::Book.search({
        title: @comic_title,
        booksGenreId: '001001',
        sort: "sales",
        hits: 50,
      })

      results.each do |result|
        comic = Comic.new(read(result))
        @comics << comic
      end
    end
  end
  
  def search_index
  end
  
  def comic_site_index
  end
  
  def show
  end
  
  private

  def read(result)
    title = result['title']
    isbn = result['isbn']
    image_url = result['mediumImageUrl'].gsub('?_ex=120x120', '')

    {
      title: title,
      isbn: isbn,
      image_url: image_url,
    }

  end
end

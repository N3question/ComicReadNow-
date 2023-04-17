class RakutenBook < ApplicationRecord
  
  # 楽天ブックスAPIから取得したデータが保存されているテーブル
  has_one :comic
  
  # 検索方法分岐
  # def self.looks(search, word)
  #   if search == "perfect_match"
  #     @rakuten_book = RakutenBook.where("title LIKE?","#{word}")
  #   elsif search == "forward_match"
  #     @rakuten_book = RakutenBook.where("title LIKE?","#{word}%")
  #   elsif search == "backward_match"
  #     @rakuten_book = RakutenBook.where("title LIKE?","%#{word}")
  #   elsif search == "partial_match"
  #     @rakuten_book = RakutenBook.where("title LIKE?","%#{word}%")
  #   else
  #     @rakuten_book = RakutenBook.all
  #   end
  # end
end

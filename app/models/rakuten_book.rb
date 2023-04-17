class RakutenBook < ApplicationRecord
  
  # 楽天ブックスAPIから取得したデータが保存されているテーブル
  has_one :comic
  
end

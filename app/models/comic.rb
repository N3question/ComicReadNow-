class Comic < ApplicationRecord
  
  self.primary_keys = :isbn
  has_one :rakuten_book
  
end
class Comic < ApplicationRecord
  
  has_many :comic_sites
  has_many :bookmarks, dependent: :destroy
  
end
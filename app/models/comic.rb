class Comic < ApplicationRecord
  
  has_many :comic_sites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :total_readable_infos, dependent: :destroy
  
end
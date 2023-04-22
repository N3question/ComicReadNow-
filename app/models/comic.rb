class Comic < ApplicationRecord
  
  has_many :comic_sites, dependent: :destroy
  has_many :sites, through: :comic_sites
  
  has_many :bookmarks, dependent: :destroy
  has_many :total_readable_infos, dependent: :destroy
  belongs_to :user
  
end
class Site < ApplicationRecord
    
  has_many :comic_sites, dependent: :destroy
  has_many :comic, through: :comic_sites
    
end

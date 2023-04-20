class Site < ApplicationRecord
    
  has_many :comic_sites, dependent: :destroy
    
end

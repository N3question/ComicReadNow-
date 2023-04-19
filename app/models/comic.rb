class Comic < ApplicationRecord
  
  # self.primary_keys = :isbn
  has_many :comic_sites
  has_many :bookmarks, dependent: :destroy
  # accepts_nested_attributes_for :comic_sites
  
end
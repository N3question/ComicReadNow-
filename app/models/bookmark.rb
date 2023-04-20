class Bookmark < ApplicationRecord

  belongs_to :user
  belongs_to :comic
  validates :user_id, uniqueness: { scope: :comic_id }
  # 一つのユーザーは同じ漫画に対して一回しかブックマークができませんというバリデーション
  
#   def bookmarked_by?(current_user)
#     bookmarks.where(user_id: current_user).exists?
#   end
end

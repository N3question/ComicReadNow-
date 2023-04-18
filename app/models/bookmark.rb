class Bookmark < ApplicationRecord

  belongs_to :user
  belongs_to :comic
  # validates_uniqueness_of :comic_id, scope: :user_id 
  # 上のコードは下の書き方と一緒　
  validates :user_id, uniqueness: { scope: :comic_id }
  # 一つのユーザーは同じ投稿に対して一回しかブックマークができませんというバリデーション
  
#   def bookmarked_by?(current_user)
#     bookmarks.where(user_id: current_user).exists?
#   end
end

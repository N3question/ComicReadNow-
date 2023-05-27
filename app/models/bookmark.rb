class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :comic
  validates :user_id, uniqueness: { scope: :comic_id }
  # 漫画(単一)に対してブックマーク1回（各user）
end

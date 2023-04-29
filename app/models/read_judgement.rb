class ReadJudgement < ApplicationRecord
    
  belongs_to :user
  belongs_to :comic
  # validates :user_id, uniqueness: { scope: :comic_id }
  # 一つのユーザーは同じ漫画に対して一回しか可読情報を押せませんというバリデーション
  
end

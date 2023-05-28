class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :profile_image
  has_many :bookmarks, dependent: :destroy
  has_many :read_judgements, dependent: :destroy
  has_many :comics, dependent: :destroy
  validates :nick_name, format: { with: /\A[a-zA-Z0-9_.!?@'%<>]+\z/, message: 'は 半角アルファベット, 指定された記号, 数字 のみ入力可能です' }, length: { maximum: 12, message: 'は12文字以内で入力してください' }, presence: true
  validates :email, presence: true
  
  PASSWORD_REGEX = /\A[a-zA-Z0-9]{6,}+\z/i.freeze
  # 半角アルファベット（大文字・小文字・数値）
  validates :password, format: { with: PASSWORD_REGEX, message: 'は 半角アルファベットと数字のみ入力可能です' }, length: { minimum: 6 }, on: :create
  
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def bookmarked?(comic_id)
    bookmarks.where(comic_id: comic_id).exists?
  end
end

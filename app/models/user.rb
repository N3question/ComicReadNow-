class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :profile_image
  has_many :bookmarks, dependent: :destroy
  has_many :readable_info_logs, dependent: :destroy
  has_many :total_readable_infos, dependent: :destroy
  has_many :comics, dependent: :destroy
  
  # PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  # # 半角アルファベット（大文字・小文字・数値）
  # validates :password, format: { with: PASSWORD_REGEX, message: 'はアルファベットと数字を含めてください' }, length: { minimum: 6 }, on: :create
  
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # def bookmarked_by?(current_user)
  #   bookmarks.where(user_id: current_user).exists?
  # end
end

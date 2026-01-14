class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :items
  has_many :buy_orders, class_name: "Order", foreign_key: ":buyer_id"
  has_many :sell_orders, class_name: "Order", foreign_key: ":seller_id"
  has_many :favorites, dependent: :destroy
  #ユーザーは たくさんの favorites を持つ
  #ユーザー削除時に その人のいいねも消す
  has_many :favorite_items, through: :favorites, source: :item
  #ユーザーはfavorites を経由してitem をたくさん持っているそれを favorite_items という名前で呼ぶ
  #N:N関係はthrough経由先が必要今はそれがfavoriteテーブル
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :create_nickname, on: :create

  has_one_attached :avatar

  validates :nickname, presence: true, uniqueness: true, length: {minimum:2, maximum:10}

  private

  def create_nickname
    return if nickname.present?

    loop do
      self.nickname = "ユーザー##{SecureRandom.hex(2)}"
      break unless User.exists?(nickname: nickname)
    end
  end
  
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :create_nickname, on: :create

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

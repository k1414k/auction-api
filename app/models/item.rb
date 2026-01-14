class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :order
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user


  enum condition: {
    new: 0,
    like_new: 1,
    used: 2
  }

  enum shipping_fee_payer: {
    seller: 0,
    buyer: 1
  }

  enum trading_status: {
    draft: 0,
    listed: 1,
    trading: 2,
    sold: 3
  }
end

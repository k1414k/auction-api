class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :order
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  enum trading_status: {
    draft: 0,
    listed: 1,
    trading: 2,
    sold: 3
  }

  # enum condition: {
  #   new: 0,
  #   like_new: 1,
  #   used: 2
  # }

  # enum shipping_fee_payer: {
  #   seller: 0,
  #   buyer: 1
  # }


  # Active Storage
  has_many_attached :images
  validate :image_type
  validate :image_size

  private

  def images_count_within_limit
    return unless images.attached?

    if images.count > 5
      errors.add(:images, "は5枚までしかアップロードできません")
    end
  end
  
  def image_type
    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:images, "はJPEG/PNG/WebPのみ対応しています")
      end
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "は5MB以下にしてください")
      end
    end
  end

end

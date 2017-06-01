class Product < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :favorites
  has_many :messages

  scope :recent, -> { order("created_at DESC") }

end

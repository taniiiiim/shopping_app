class Product < ApplicationRecord
  belongs_to :gender
  belongs_to :category
  belongs_to :size
  has_many :stocks, dependent: :destroy
  has_many :details

  mount_uploader :picture, PictureUploader

  validates :name, presence: :true, length: { maximum: 100 },
                   uniqueness: :true
  validates :gender_id, presence: :true
  validates :category_id, presence: :true
  validates :size_id, presence: :true
  validates :price, presence: :true, numericality: { more_than_or_equal_to: 0, less_than_or_equal_to: 100000}
  validates :abstract, presence: :true, length: { maximum: 512 }
  validate  :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end

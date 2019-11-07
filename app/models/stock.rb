class Stock < ApplicationRecord
  belongs_to :product

  validates :product_id, presence: true
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100000 }

end

class Detail < ApplicationRecord
  belongs_to :order

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100000 }

end

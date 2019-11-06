class Order < ApplicationRecord
  attr_accessor :order_token

  belongs_to :user
  has_many :details, dependent: :destroy

  VALID_CODE_REGEX = /\A[0-9]+[0-9]+[0-9]+[-]+[0-9]+[0-9]+[0-9]+[0-9]\z/i
  validates :code, presence: true, length: { is: 8 }, format: { with: VALID_CODE_REGEX }, allow_nil: true
  validates :address, presence: true, length: { maximum: 255 }, allow_nil: true

  def Order.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Order.new_token
    SecureRandom.urlsafe_base64
  end

  def create_cart
    self.order_token = Order.new_token
    update_attribute(:order_digest, Order.digest(order_token))
  end

  def send_order_create_email
    OrderMailer.order_create(self).deliver_now
  end

  def send_order_update_email
    OrderMailer.order_update(self).deliver_now
  end

  def send_order_delete_email
    OrderMailer.order_delete(self).deliver_now
  end

  def cart_created_expired?
    cart_created_at < 30.minutes.ago
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def cancel
    update_attribute(:order_digest, nil)
  end

end

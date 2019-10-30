class User < ApplicationRecord

  validates :name, presence: true, length: { maximum: 50 }
  validates :real_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitivce: true }, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6, maximum: 20 }
  validates :gender, presence: true
  VALID_CODE_REGEX = /\A[0-9]+[0-9]+[0-9]+[-]+[0-9]+[0-9]+[0-9]+[0-9]\z/i
  validates :code, presence: true, length: { is: 8 }, format: { with: VALID_CODE_REGEX }
  validates :address, presence: true, length: { maximum: 255 }

end

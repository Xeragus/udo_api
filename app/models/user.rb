class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :full_name, presence: true

  has_many :tasks
  has_many :tags, through: :tasks
end

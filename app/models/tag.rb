class Tag < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true

  belongs_to :user, optional: true
  has_many :tasks_tags
  has_many :tasks, through: :tasks_tags
end

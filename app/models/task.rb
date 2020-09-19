class Task < ApplicationRecord
  validates :name, presence: true
  validates :deadline, presence: true

  has_many :tasks_tags
  has_many :tags, through: :tasks_tags
end

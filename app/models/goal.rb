class Goal < ApplicationRecord
  validates :name, presence: true
  validates :measured_in, presence: true
  validates :start_from, presence: true
  validates :target, presence: true
  validates :deadline, presence: true
  validates :user_id, presence: true
end

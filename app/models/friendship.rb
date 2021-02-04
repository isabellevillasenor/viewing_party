class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  enum status: { pending: 0, approved: 1 }

  scope :pending, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
end

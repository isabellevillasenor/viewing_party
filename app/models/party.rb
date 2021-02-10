class Party < ApplicationRecord
  validates :party_time, presence: true
  validates :party_duration, numericality: { greater_than: 0 }

  belongs_to :host, class_name: 'User'
  belongs_to :movie
  has_many :invitations, dependent: :destroy
  has_many :party_people, through: :invitations

  delegate :title, to: :movie, prefix: true
end

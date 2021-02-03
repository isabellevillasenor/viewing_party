class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
  validates :name, presence: true

  has_secure_password

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :parties, dependent: :destroy, foreign_key: 'host_id'
  has_many :invitations, dependent: :destroy, foreign_key: 'party_person_id'
end

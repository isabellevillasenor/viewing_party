class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true

  has_secure_password

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :parties, dependent: :destroy, inverse_of: :host
  has_many :invitations, dependent: :destroy, inverse_of: :party_person

  before_save { email.try(:downcase!) }

  def name
    self[:name].presence || email
  end

  def add_friend(email)
    friend = User.find_by_email(email)
    friends << friend if friend
  end
end

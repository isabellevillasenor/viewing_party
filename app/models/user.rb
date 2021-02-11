class User < ApplicationRecord
  validates :email,
            uniqueness: true,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  has_secure_password

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many  :inverse_friendships,
            dependent: :destroy,
            class_name: 'Friendship',
            foreign_key: 'friend_id',
            inverse_of: :friend
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :parties, dependent: :destroy, inverse_of: :host
  has_many :invitations, dependent: :destroy, inverse_of: :party_person

  before_save { email.try(:downcase!) }

  scope :approved, -> { where(friendships: { status: 1 }) }
  scope :pending, -> { select('users.*, friendships.id AS join_id').where(friendships: { status: 0 }) }

  def name
    self[:name].presence || email
  end

  def all_friends
    friends + inverse_friends
  end

  def approved_friends
    friends.approved + inverse_friends.approved
  end

  def sent_requests
    friends.pending
  end

  def received_requests
    inverse_friends.pending
  end
end

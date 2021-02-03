class Invitation < ApplicationRecord
  belongs_to :party
  belongs_to :party_person, class_name: 'User'
end

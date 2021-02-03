require 'rails_helper'

describe Party do
  describe 'validations' do
    it { should validate_presence_of :party_time }
    it { should validate_numericality_of(:party_duration).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :host }
    it { should belong_to :movie }
    it { should have_many :invitations }
    it { should have_many(:party_people).through(:invitations) }
  end
end
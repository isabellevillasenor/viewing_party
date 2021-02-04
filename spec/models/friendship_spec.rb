require 'rails_helper'

describe Friendship do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :friend }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values([:pending, :approved]) }
  end

  describe 'scopes' do
    before(:each) do
      user = create(:user)
      friend = create(:user)
      @pending_friendship = user.friendships.create(friend: friend)
      @approved_friendship = user.friendships.create(friend: friend, status: 1)
    end

    it { expect(Friendship.pending).to eq([@pending_friendship]) }
    it { expect(Friendship.approved).to eq([@approved_friendship]) }
  end
end

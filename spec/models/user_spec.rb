require 'rails_helper'

describe User do
  describe 'relationships' do
    it { should have_many :friendships }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many :inverse_friendships }
    it { should have_many(:inverse_friends).through(:inverse_friendships) }
    it { should have_many(:parties).dependent(:destroy) }
    it { should have_many(:invitations).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
  end

  describe 'instance methods' do
    it '#before_save' do
      user = create(:user, email: 'EMAIL@EMAIL.COM')

      expect(user.email).to eq('email@email.com')
    end

    it '#name' do
      user = create(:user, name: "")

      expect(user.name).to eq(user.email)

      user.update(name: 'Steve')

      expect(user.name).to eq('Steve')
    end

    describe '#add_friend' do
      let(:user) { create(:user)}

      it 'adds friends who are users' do
        friend = create(:user)

        result = user.add_friend(friend.email)
        expect(user.friends).to eq([friend])
      end

      it 'returns nil if the email does not belong to a user' do
        email = Faker::Internet.email

        result = user.add_friend(email)
        expect(result).to eq(nil)
        expect(user.friends).to eq([])
      end
    end

    describe 'friend groups' do
      before(:each) do
        user = create(:user)
        added_friend = create(:user)
        inverse_friend = create(:user)
        approved_friend = create(:user)
        approved_inverse_friend = create(:user)

        user.add_friend(added_friend.email)
        inverse_friend.add_friend(user.email)
        create(:friendship, user: user, friend: approved_friend, status: 1)
        create(:friendship, user: approved_inverse_friend, friend: user, status: 1)
      end
      
      it '#approved_friends' do
        expect(user.all_friends.to_set).to eq([approved_friend, approved_inverse_friend].to_set)
      end

      it '#pending_friends' do
        expect(user.pending_friends).to eq([added_friend])
      end

      it '#pending_requests' do
        expect(user.pending_friends).to eq([inverse_friend])
      end
    end
  end
end

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

    it '#all_friends' do
      user = create(:user)
      friend = create(:user)
      
      friend.add_friend(user.email)
      expect(user.all_friends).to eq([friend])
    end
  end
end

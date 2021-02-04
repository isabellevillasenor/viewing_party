require 'rails_helper'

describe User do
  describe 'relationships' do
    it { should have_many :friendships }
    it { should have_many(:friends).through(:friendships) }
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
      user = create(:user)

      expect(user.name).to eq(user.email)

      user.update(name: 'Steve')

      expect(user.name).to eq('Steve')
    end

    describe '#add_friend' do
      let(:user) { create(:user)}

      it 'adds friends who are users' do
        friend = create(:user)

        result = user.add_friend(friend.email)
        expect(result).to eq(true)
        expect(user.friends).to eq([friend])
      end

      it 'returns false if the email does not belong to a user' do
        email = Faker::Internet.email

        result = user.add_friend(email)
        expect(result).to eq(false)
        expect(user.friends).to eq([])
      end
    end
  end
end

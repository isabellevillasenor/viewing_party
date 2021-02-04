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
      user = User.create(email: 'EMAIL@EMAIL.COM', password: 'test')

      expect(user.email).to eq('email@email.com')
    end

    it '#name' do
      user = User.create(email: 'email@email.com', password: 'test')

      expect(user.name).to eq('email@email.com')

      user.update(name: 'Steve')

      expect(user.name).to eq('Steve')
    end
  end
end

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

    describe 'friend groups' do
      before(:each) do
        @user = create(:user)
        @added_friend = create(:user)
        @inverse_friend = create(:user)
        @approved_friend = create(:user)
        @approved_inverse_friend = create(:user)

        create(:friendship, user: @user, friend: @added_friend)
        create(:friendship, user: @inverse_friend, friend: @user)
        create(:friendship, user: @user, friend: @approved_friend, status: 1)
        create(:friendship, user: @approved_inverse_friend, friend: @user, status: 1)
      end

      it '#all_friends' do
        friends = [@added_friend, @inverse_friend, @approved_friend, @approved_inverse_friend]
        expect(@user.all_friends.to_set).to eq(friends.to_set)
      end

      it '#approved_friends' do
        expect(@user.approved_friends.to_set).to eq([@approved_friend, @approved_inverse_friend].to_set)
      end

      it '#sent_requests' do
        expect(@user.sent_requests).to eq([@added_friend])
      end

      it '#received_requests' do
        expect(@user.received_requests).to eq([@inverse_friend])
      end

      it 'approved scope' do
        expect(@user.friends.approved).to eq([@approved_friend])
        expect(@user.inverse_friends.approved).to eq([@approved_inverse_friend])
      end
    end

    describe 'upcoming parties' do
      it '#upcoming_parties' do
        @user = create(:user)
        @friend = create(:user)
        create(:friendship, user: @user, friend: @friend)

        @movie = Movie.create(api_ref: 12345, title: 'Movie 1')
        @party1 = Party.create(party_time: DateTime.now.tomorrow, party_duration: 180, host_id: @user.id, movie_id: @movie.id)
        @party2 = Party.create(party_time: DateTime.now.tomorrow, party_duration: 240, host_id: @friend.id, movie_id: @movie.id)
        @party3 = Party.create(party_time: DateTime.now.yesterday, party_duration: 240, host_id: @friend.id, movie_id: @movie.id)

        Invitation.create(party_person_id: @friend.id, party_id: @party1.id)
        Invitation.create(party_person_id: @user.id, party_id: @party2.id)
        Invitation.create(party_person_id: @user.id, party_id: @party3.id)

        expect(@user.upcoming_parties).to eq([@party1, @party2])
      end
    end
  end
end

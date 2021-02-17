require 'rails_helper'

describe 'Dashboard Index' do
  it 'displays a welcome header for logged in user' do
    user = create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button 'Log In'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{user.name}!")
  end

  it 'it has a button to discover movies that routes to /discover' do
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path

    expect(page).to have_button('Discover Movies')
  end


  describe 'friends section' do
    before(:each) do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'exists' do
      visit dashboard_path

      expect(page).to have_content('Friends')
      within('.friends') {expect(page).to have_button('Add Friend')}
    end

    it 'starts with no friends' do
      visit dashboard_path

      expect(page).to have_content("You haven't added any friends yet")
    end

    it "displays the user's friends" do
      friends = create_list(:friend, 3, user: @user)
      not_friend = create(:user)

      visit dashboard_path

      within('.friends') do
        friends.each do |friend|
          expect(page).to have_content(friend.name)
          expect(page).to have_content(friend.email)
        end
        expect(page).not_to have_content(not_friend.name)
        expect(page).not_to have_content(not_friend.email)
      end
    end

    describe 'friend requests' do
      before(:each) do
        @user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'shows new friends as pending until they have been approved' do
        friend = create(:user)
        create(:friendship, user: @user, friend: friend)

        visit dashboard_path

        within('#sent') do
          expect(page).to have_content(friend.name)
          expect(page).to have_content(friend.email)
          expect(page).to have_button('Cancel')
        end

        within('#approved-friends') do
          expect(page).not_to have_content(friend.name)
          expect(page).not_to have_content(friend.email)
        end
      end

      it 'shows pending friend requests with the option to approve or deny' do
        friend = create(:user)
        create(:friendship, user: friend, friend: @user)

        visit dashboard_path

        within('#received') do
          expect(page).to have_content(friend.name)
          expect(page).to have_content(friend.email)
          expect(page).to have_button('Approve')
          expect(page).to have_button('Deny')
        end

        within('#approved-friends') do
          expect(page).not_to have_content(friend.name)
          expect(page).not_to have_content(friend.email)
        end
      end

      it 'adds friends to approved friend list when approved' do
        friend = create(:user)
        create(:friendship, user: friend, friend: @user)

        visit dashboard_path

        click_button('Approve')

        within('.pending-requests') do
          expect(page).not_to have_content(friend.name)
          expect(page).not_to have_content(friend.email)
        end

        within('#approved-friends') do
          expect(page).to have_content(friend.name)
          expect(page).to have_content(friend.email)
        end

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(friend)

        visit dashboard_path

        within('#approved-friends') do
          expect(page).to have_content(@user.name)
          expect(page).to have_content(@user.email)
        end

        within('.pending-requests') do
          expect(page).not_to have_content(@user.name)
          expect(page).not_to have_content(@user.email)
        end
      end

      it 'does not add friends to friend list when not approved' do
        friend = create(:user)
        create(:friendship, user: friend, friend: @user)

        visit dashboard_path

        click_button('Deny')

        expect(page).not_to have_content(friend.name)
        expect(page).not_to have_content(friend.email)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(friend)

        visit dashboard_path

        expect(page).not_to have_content(@user.name)
        expect(page).not_to have_content(@user.email)
      end

      it 'user can cancel pending friend requests' do
        friend = create(:user)
        create(:friendship, user: @user, friend: friend)

        visit dashboard_path
        click_button('Cancel')

        expect(page).not_to have_content(friend.name)
        expect(page).not_to have_content(friend.email)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(friend)

        visit dashboard_path

        expect(page).not_to have_content(@user.name)
        expect(page).not_to have_content(@user.email)
      end
    end

    describe 'friend search' do
      it 'has a search field to find friends by email' do
        visit dashboard_path

        expect(page).to have_field(:email, placeholder: 'Search by email')
      end

      it 'locates friends who are existing users' do
        friend = create(:user)

        visit dashboard_path

        fill_in(:email, with: friend.email)
        click_button('Add Friend')

        expect(page).to have_content(friend.name)
        expect(page).to have_content(friend.email)
      end

      it 'displays an error message if the friend cannot be located' do
        visit dashboard_path

        email = Faker::Internet.email
        fill_in(:email, with: email)
        click_button('Add Friend')

        expect(page).to have_content("Unable to locate user #{email}")
        within('.friends') {expect(page).not_to have_content(email)}
      end
    end

    describe 'party section' do
      before(:each) do
        @user = create(:user)
        @friend = create(:user)
        create(:friendship, user: @user, friend: @friend)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        @movie = Movie.create(api_ref: 12345, title: 'Movie 1')
        @party = Party.create(party_time: DateTime.now, party_duration: 180, host_id: @user.id, movie_id: @movie.id)
        Invitation.create(party_person_id: @friend.id, party_id: @party.id)
      end

      it 'displays parties with the status of host/invite' do
        visit dashboard_path

        within(".parties") do
          expect(page).to have_content(@movie.title)
          expect(page).to have_content(@party.party_time.strftime('%B %-d, %Y'))
          expect(page).to have_content(@party.party_time.strftime('%l:%M %p'))
          expect(page).to have_content('Hosting')
        end

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@friend)
        visit dashboard_path

        within(".parties") do
          expect(page).to have_content(@movie.title)
          expect(page).to have_content(@party.party_time.strftime('%B %-d, %Y'))
          expect(page).to have_content(@party.party_time.strftime('%l:%M %p'))
          expect(page).to have_content('Invited')
        end
      end
    end
  end
end

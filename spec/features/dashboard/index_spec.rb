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

      expect(page).to have_content('You currently have no friends.')
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

        within('#pending-friends') do
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

        within('#pending-requests') do
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

        within('#pending-requests') do
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

        within('#pending-friends') do
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
  end
end

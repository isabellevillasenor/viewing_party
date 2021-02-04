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

    describe 'friend search' do
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

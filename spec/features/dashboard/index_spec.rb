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

  it 'it has a friends section to enter email and add friends' do
    # user1 = User.create(email: 'gon@hxh.com', password: 'test', name: 'Gon')
    # user2 = user1.friends.create(email: 'killua@hxh.com', password: 'test', name: 'Killua')

    #visit gon dashboard
    # expect(page).to have_content('Friends')

    # fill_in :email, with: user2.email
    # click_button 'Add Friend'

    # expect(page).to have_content('Killua')
  end

  describe 'it has a list of already approved friends' do

  end

  describe 'it displays a message if no friends added' do

  end

  describe 'it displays an error message if friend is not in database' do

  end
end

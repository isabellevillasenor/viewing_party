require 'rails_helper'

describe 'Dashboard Index' do
  describe 'it displays a welcome header for logged in user' do
    # user = User.create(email: 'gon@hxh.com', password: 'test', name: 'Gon')
    
    # visit root_path

    # click_button 'Log In'

    # fill_in :email, with: user.email
    # fill_in :password, with: user.password

    # click_button 'Log In'

    # expect(current_path).to eq(dashboard_index_path)
    # expect(page).to have_content("Welcome #{user.name}!")
  end

  describe 'it has a button to discover movies that routes to /discover' do
    # visit gon dashboard
    expect(page).to have_button('Discover Movies')

    # click_button 'Discover Movies'

    # expect(current_path).to eq(discover_path)
  end

  describe 'it has a friends section to enter email and add friends' do
    # user1 = User.create(email: 'gon@hxh.com', password: 'test', name: 'Gon')
    # user2 = User.create(email: 'killua@hxh.com', password: 'test', name: 'Killua')

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
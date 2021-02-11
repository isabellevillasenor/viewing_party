require 'rails_helper'

RSpec.describe 'logging in' do
  let(:user) {create(:user)}

  it 'login page has a link to register' do
    visit login_path

    expect(page).to have_link("Register", href: registration_path)
  end

  it 'can log in with valid credentials' do
    visit login_path

    fill_in(:email, with: user.email)
    fill_in(:password, with: user.password)
    click_button('Log In')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{user.name}!")
  end

  describe 'sad path' do
    it 'cannot log in with invalid password' do
      visit login_path

      fill_in(:email, with: user.email)
      fill_in(:password, with: user.password.chop)
      click_button('Log In')

      expect(page).to have_content("Invalid Email or Password")
    end

    it 'cannot log in with invalid email' do
      visit login_path

      fill_in(:email, with: Faker::Internet.email)
      fill_in(:password, with: Faker::Internet.password)
      click_button('Log In')

      expect(page).to have_content("Invalid Email or Password")
    end
  end

  it 'logging out' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path

    click_button('Log Out')

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Successfully logged out")
  end
end

require 'rails_helper'

RSpec.describe 'user registration' do
  it 'creates a new user' do
    visit registration_path

    email = Faker::Internet.email
    password = Faker::Internet.password
    name = Faker::Name.first_name

    fill_in('user[email]', with: email)
    fill_in('user[password]', with: password)
    fill_in('user[password_confirmation]', with: password)
    fill_in('user[name]', with: name)
    click_button('Register')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{name}!")
  end

  describe 'sad paths' do
    it 'requires an email address and password' do
      visit registration_path

      click_button('Register')

      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

    it 'validates that the password entries match' do
      visit registration_path

      email = Faker::Internet.email
      password = Faker::Internet.password

      fill_in('user[email]', with: email)
      fill_in('user[password]', with: password)
      fill_in('user[password_confirmation]', with: password.chop)
      click_button('Register')

      expect(page).to have_content("Passwords do not match")
    end
  end

  it 'can use an email address as a name if none is provided' do
    visit registration_path

    email = Faker::Internet.email
    password = Faker::Internet.password

    fill_in('user[email]', with: email)
    fill_in('user[password]', with: password)
    fill_in('user[password_confirmation]', with: password)
    click_button('Register')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{email}!")
  end
end

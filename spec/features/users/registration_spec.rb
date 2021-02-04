require 'rails_helper'

RSpec.describe 'user registration' do
  before(:each) { visit registration_path }
  let(:email) {Faker::Internet.email}
  let(:password) {Faker::Internet.password}
  let(:name) {Faker::Name.first_name}

  it 'has a welcome message' do
    expect(page).to have_content("Welcome to Viewing Party")
    expect(page).to have_content("Please Register for an Account")
  end

  it 'has a link to the login page' do
    expect(page).to have_link('Already Registered? Log in Here', href: login_path)
  end

  it 'creates a new user' do
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
      click_button('Register')

      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

    it 'validates that the password entries match' do
      fill_in('user[email]', with: email)
      fill_in('user[password]', with: password)
      fill_in('user[password_confirmation]', with: password.chop)
      click_button('Register')

      expect(page).to have_content("Password confirmation doesn't match")
    end
  end

  it 'can use an email address as a name if none is provided' do
    fill_in('user[email]', with: email)
    fill_in('user[password]', with: password)
    fill_in('user[password_confirmation]', with: password)
    click_button('Register')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{email}!")
  end

  it 'email is not case sensitive' do
    fill_in('user[email]', with: email.upcase)
    fill_in('user[password]', with: password)
    fill_in('user[password_confirmation]', with: password)
    click_button('Register')

    expect(page).to have_content("Welcome, #{email}!")
  end
end

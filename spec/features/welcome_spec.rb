require 'rails_helper'

RSpec.describe 'Welcome' do
  before(:each) { visit root_path }
  let(:email) {Faker::Internet.email}
  let(:password) {Faker::Internet.password}
  let(:name) {Faker::Name.first_name}

  it 'displays a welcome message' do
    expect(page).to have_content('Welcome to Viewing Party!')
  end

  it 'displays a description of the application' do
    expect(page).to have_content('Explore movies and create a viewing party event for you and your friends!')
  end

  it 'has a button to log in' do
    expect(page).to have_link('Log In')

    click_link 'Log In'

    expect(current_path).to eq(login_path)
  end

  it 'has a button to register' do
    expect(page).to have_link('Register', href: registration_path)
  end
end

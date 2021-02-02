require 'rails_helper'

RSpec.describe 'Welcome' do
  before(:each) { visit root_path }

  it 'displays a welcome message' do
    expect(page).to have_content('Welcome to Viewing Party!')
  end

  it 'displays a description of the application' do
    expect(page).to have_content('an application to explore movies and create a viewing party event for you and your friends to watch a movie together')
  end

  it 'has a button to log in' do
    expect(page).to have_button('Log In')
  end

  it 'has a button to register' do
    expect(page).to have_link('Register')
  end
end

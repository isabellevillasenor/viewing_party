require 'rails_helper'

describe 'movies index page' do
  it 'has a Find Top Rated Movies button that redirects to ___' do
    user = create(:user)

    visit discover_path

    expect(page).to have_button('Find Top Rated Movies')

    # click_button 'Find Top Rated Movies'
    # expect(current_path).to eq()
  end
end

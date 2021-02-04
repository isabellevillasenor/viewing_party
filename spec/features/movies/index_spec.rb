require 'rails_helper'

describe 'movies index page' do
  it 'has a Find Top Rated Movies button that redirects to ___' do
    user = create(:user)

    visit discover_path

    expect(page).to have_button('Find Top Rated Movies')

    # click_button 'Find Top Rated Movies'
    # expect(current_path).to eq()
  end

  it "has a search by movie title field with a button to Find Movies that redirects to ____" do
    user = create(:user)

    visit discover_path

    expect(page).to have_content('Movie Title')
    expect(page).to have_button('Find Movies')

    # fill_in :title, with: ???
    # click_button 'Find Movies'
    # expect(current_path).to eq()
    # expect(page).to have_content(SOME MOVIE'S INFO)
  end
end

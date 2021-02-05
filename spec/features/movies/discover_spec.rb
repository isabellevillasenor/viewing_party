require 'rails_helper'

describe 'movies discover page' do
  it 'has a Find Top Rated Movies button that redirects to the movies index page' do
    visit discover_path

    click_button 'Find Top Rated Movies'
    expect(current_path).to eq(movies_path)
  end

  it 'has a search by movie title field with a button to Find Movies that redirects to movies index page' do
    visit discover_path

    expect(page).to have_field(:title, placeholder: 'Search by movie title')

    fill_in :title, with: 'Phoenix'
    click_button 'Find Movies'
    expect(current_path).to eq(movies_path)
  end
end

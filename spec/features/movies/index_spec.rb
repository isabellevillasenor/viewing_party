require 'rails_helper'

describe 'movies index page' do
  it 'has a Find Top Rated Movies button that redirects to the movies index page' do
    visit movies_path

    click_button 'Find Top Rated Movies'
    expect(current_path).to eq(movies_path)
  end

  it 'returns the top 40 movies and their vote average' do
    visit movies_path
    
    click_button 'Find Top Rated Movies'

    movie = page.all('li').first

    expect(page).to have_css('li', count: 40)
    expect(movie.has_link?).to be true
    expect(movie).to have_content('Vote Average:')
  end

  it 'has a search by movie title field with a button to Find Movies that redirects to movies index page' do
    visit movies_path

    expect(page).to have_field(:title, placeholder: 'Search by movie title')

    fill_in :title, with: 'Phoenix'
    click_button 'Find Movies'
    expect(current_path).to eq(movies_path)
  end

  it 'has search results from entered criteria' do
    visit movies_path

    fill_in :title, with: 'Phoenix'
    click_button 'Find Movies'
    expect(page).to have_content('Phoenix').at_least(1)
  end
end

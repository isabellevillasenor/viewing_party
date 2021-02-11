require 'rails_helper'

describe 'movies index page' do
  let(:movies) { build_list(:movie_proxy, 40) }

  describe 'top movies' do
    it 'has a Find Top Rated Movies button that redirects to the movies index page' do
      allow(MoviesFacade).to receive(:top_movies).and_return([])

      visit movies_path

      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(movies_path)
    end

    it 'returns the top 40 movies and their vote average' do
      allow(MoviesFacade).to receive(:top_movies).and_return(movies)

      visit movies_path

      click_button 'Find Top Rated Movies'

      expect(page).to have_css('li', count: 40)
      movies.each do |movie|
        expect(page).to have_link(movie.title, href: movie_path(api_ref: movie.api_ref))
        expect(page).to have_content("Vote Average: #{movie.vote_average}")
      end
    end
  end

  describe 'movies search' do
    it 'has a search by movie title field with a button to Find Movies that redirects to movies index page' do
      allow(MoviesFacade).to receive(:search_movies).and_return([])
      visit movies_path

      expect(page).to have_field(:title, placeholder: 'Search by movie title')

      fill_in :title, with: 'Phoenix'
      click_button 'Find Movies'

      expect(current_path).to eq(movies_path)
    end

    it 'has search results from entered criteria' do
      allow(MoviesFacade).to receive(:search_movies).and_return(movies)

      visit movies_path
      fill_in :title, with: "Phoenix"
      click_button 'Find Movies'

      expect(page).to have_css('li', count: 40)
      movies.each do |movie|
        expect(page).to have_link(movie.title, href: movie_path(api_ref: movie.api_ref))
        expect(page).to have_content("Vote Average: #{movie.vote_average}")
      end
    end
  end
end

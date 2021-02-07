require 'rails_helper'

describe 'Movies Show Page' do
  before :each do
    data = File.read('spec/fixtures/movie_details.json')
    movie_data = JSON.parse(data, symbolize_names: true)
    @movie = MovieProxy.new(movie_data)
  end
  
  it 'displays the movie details' do
    VCR.use_cassette('movie_details') do
      visit "/movies/#{@movie.id}"
      
      expect(page).to have_content(@movie.title)
      expect(page).to have_content("Vote Average: #{@movie.vote_average}")
      expect(page).to have_content("Runtime: #{@movie.runtime}")
      expect(page).to have_content("Genre(s): #{@movie.genres.join(', ')}")
    end
  end

  it 'has a section with summary' do
    VCR.use_cassette('movie_details') do
      visit "/movies/#{@movie.id}"
      
      within('#summary') do
        expect(page).to have_content(@movie.overview)
      end
    end
  end

  it 'displays a section with the cast' do
    VCR.use_cassette('movie_details') do
      visit "/movies/#{@movie.id}"

      within('#cast') do
      #make file to read
        expect(page).to have_content(@actors.name)
        expect(page).to have_content(@actors.character)
      end
    end
  end

  it 'has a section for reviews' do
    review = @movie.reviews.sample

    within('#reviews') do
      expect(page).to have_content("#{@movie.reviews.size} Reviews")
      within("#reviews-#{review.id}") do
        expect(page).to have_content(review.author)
        expect(page).to have_content(review.author_review)
      end
    end
  end

  it 'has a button to create a viewing party' do
    expect(page).to have_button('Create Viewing Party!') 
    
    click_button
    expect(current_path).to eq(new_party_path)
  end
end
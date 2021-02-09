require 'rails_helper'

describe 'Movies Show Page' do
  before :each do
    data = File.read('spec/fixtures/movie_details.json')
    movie_data = JSON.parse(data, symbolize_names: true)
    @movie = MovieProxy.new(movie_data)
    data = File.read('spec/fixtures/actors.json')
    actors_data = JSON.parse(data, symbolize_names: true)
    @actors = actors_data[:cast][0..10].map do |actor|
      Actor.new(actor)
    end
    data = File.read('spec/fixtures/reviews.json')
    @reviews_data = JSON.parse(data, symbolize_names: true)
    @reviews = @reviews_data[:results].map do |review|
      Review.new(review)
    end
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
        @actors[0..9].each do |actor|
          expect(page).to have_content(actor.name)
          expect(page).to have_content(actor.character)
        end
        expect(page).to_not have_content(@actors[10].name)
        expect(page).to_not have_content(@actors[10].character)
      end
    end
  end

  it 'has a section for reviews' do
    VCR.use_cassette('movie_details') do
      visit "/movies/#{@movie.id}"

      within('#reviews') do
        expect(page).to have_content("#{@reviews_data[:total_results]} Reviews")
        @reviews.each do |review|
          within("#review-#{review.id}") do
            expect(page).to have_content(review.author)
            # expect(page).to have_content(review.content.gsub("\n", " "))
          end
        end
      end
    end
  end

  it 'has a button to create a viewing party' do
    VCR.use_cassette('movie_details') do
      visit "/movies/#{@movie.id}"
      expect(page).to have_button('Create Viewing Party!')

      click_button
      expect(current_path).to eq(new_party_path)
    end
  end
end

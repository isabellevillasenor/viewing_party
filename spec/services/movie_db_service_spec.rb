require 'rails_helper'

RSpec.describe MovieDbService do
  describe '.top_movies' do
    it 'returns the top 40 movies' do
      VCR.use_cassette('top_rated_movies') do
        movies = MovieDbService.top_movies

        expect(movies).to be_an(Array)

        first_movie = movies[0]
        expect(first_movie).to be_a(Hash)
        expect(first_movie).to have_key(:title)
        expect(first_movie[:title]).to be_a(String)
        expect(first_movie).to have_key(:vote_average)
        expect(first_movie[:vote_average]).to be_a(Numeric)
        expect(first_movie).to have_key(:id)
        expect(first_movie[:id]).to be_a(Numeric)
        expect(movies.size).to eq(40)
      end
    end
  end

  describe '.search_movies' do
    it 'returns search results' do
      VCR.use_cassette('search_movies') do
        movies = MovieDbService.search_movies("Phoenix")

        expect(movies).to be_an(Array)

        first_movie = movies[0]
        expect(first_movie).to be_a(Hash)
        expect(first_movie).to have_key(:title)
        expect(first_movie[:title]).to be_a(String)
        expect(first_movie).to have_key(:vote_average)
        expect(first_movie[:vote_average]).to be_a(Numeric)
        expect(first_movie).to have_key(:id)
        expect(first_movie[:id]).to be_a(Numeric)
        expect(movies.size).to be <= 40
      end
    end
  end
end

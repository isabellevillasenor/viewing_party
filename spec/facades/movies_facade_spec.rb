require 'rails_helper'

RSpec.describe MoviesFacade do
  describe '.top_movies' do
      it 'gets the top 40 movies' do
        VCR.use_cassette('top_rated_movies') do
        movies = MoviesFacade.top_movies

        expect(movies).to be_an(Array)
        expect(movies[0]).to be_a(MovieProxy)
      end
    end
  end

  describe '.search_movies' do
    it 'gets up to 40 movies matching a search phrase' do
      VCR.use_cassette('search_movies') do
        movies = MoviesFacade.search_movies("Phoenix".parameterize)

        expect(movies).to be_an(Array)
        expect(movies[0]).to be_a(MovieProxy)
      end
    end
  end

  describe '.movie_details' do
    it 'gets details for the specified movie' do
      VCR.use_cassette('movie_details') do
        movie = MoviesFacade.movie_details(324857)

        expect(movie).to be_a(MovieProxy)
      end
    end
  end

  describe '.cast_details' do
    it 'gets the cast for the specified movie' do
      VCR.use_cassette('movie_details') do
        cast = MoviesFacade.cast_details(324857)

        expect(cast).to be_an(Array)
        expect(cast[0]).to be_an(Actor)
      end
    end
  end

  describe '.review_details' do
    it 'gets reviews for the specified movie' do
      VCR.use_cassette('movie_details') do
        reviews = MoviesFacade.review_details(324857)

        expect(reviews).to be_an(Array)
        expect(reviews[0]).to be_a(Review)
      end
    end
  end
end

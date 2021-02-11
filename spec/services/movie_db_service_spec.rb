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

    it 'search with one page', :vcr do
      movies = MovieDbService.search_movies("yellow submarine")

      expect(movies).to be_an(Array)

      first_movie = movies[0]
      expect(first_movie).to be_a(Hash)
      expect(first_movie).to have_key(:title)
      expect(first_movie[:title]).to be_a(String)
      expect(first_movie).to have_key(:vote_average)
      expect(first_movie[:vote_average]).to be_a(Numeric)
      expect(first_movie).to have_key(:id)
      expect(first_movie[:id]).to be_a(Numeric)
      expect(movies.size).to be <= 20
    end

    it 'search with spaces', :vcr do
      movies = MovieDbService.search_movies("independence day")

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

  describe '.movie_details' do
    it 'returns movie details' do
      VCR.use_cassette('movie_details') do
        results = MovieDbService.movie_details(324857)

        expect(results).to be_a(Hash)
        expect(results).to have_key(:title)
        expect(results[:title]).to be_a(String)
        expect(results).to have_key(:vote_average)
        expect(results[:vote_average]).to be_a(Numeric)
        expect(results).to have_key(:id)
        expect(results[:id]).to be_a(Numeric)
        expect(results).to have_key(:runtime)
        expect(results[:runtime]).to be_a(Numeric)
        expect(results).to have_key(:genres)
        expect(results[:genres]).to be_a(Array)
        expect(results).to have_key(:overview)
        expect(results[:overview]).to be_a(String)
      end
    end
  end

  describe '.cast_details' do
    it 'returns cast members' do
      VCR.use_cassette('cast_details') do
        results = MovieDbService.cast_details(324857)

        expect(results).to be_a(Hash)
        expect(results).to have_key(:cast)
        expect(results[:cast]).to be_an(Array)
        first_actor = results[:cast][0]
        expect(first_actor).to be_a(Hash)
        expect(first_actor).to have_key(:name)
        expect(first_actor[:name]).to be_a(String)
        expect(first_actor).to have_key(:character)
        expect(first_actor[:character]).to be_a(String)
      end
    end

    it 'fewer than 10 cast members', :vcr do
      results = MovieDbService.cast_details(503919)

      expect(results).to be_a(Hash)
      expect(results).to have_key(:cast)
      expect(results[:cast]).to be_an(Array)
      first_actor = results[:cast][0]
      expect(first_actor).to be_a(Hash)
      expect(first_actor).to have_key(:name)
      expect(first_actor[:name]).to be_a(String)
      expect(first_actor).to have_key(:character)
      expect(first_actor[:character]).to be_a(String)
    end
  end

  describe '.review_details' do
    it 'returns review details' do
      VCR.use_cassette('review_details') do
        reviews = MovieDbService.review_details(324857)

        expect(reviews).to be_a(Array)
        first_review = reviews[0]
        expect(first_review).to be_a(Hash)
        expect(first_review).to have_key(:author)
        expect(first_review[:author]).to be_a(String)
        expect(first_review).to have_key(:content)
        expect(first_review[:content]).to be_a(String)
      end
    end
    
    it 'no reviews', :vcr do
      reviews = MovieDbService.review_details(503919)

      expect(reviews).to be_a(Array)
      first_review = reviews[0]
      expect(first_review).to be_a(Hash)
      expect(first_review).to have_key(:author)
      expect(first_review[:author]).to be_a(String)
      expect(first_review).to have_key(:content)
      expect(first_review[:content]).to be_a(String)
    end
  end
end

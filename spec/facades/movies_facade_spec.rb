require 'rails_helper'

RSpec.describe MoviesFacade do
  let(:movie_info) { {
    title: "Independence Day",
    vote_average: 6.8,
    id: 602,
    runtime: 145,
    overview: "Will Smith and Jeff Goldblum save the world from aliens",
    genres: [ {id: 28, name: "Action"},
              {id: 12, name: "Adventure"},
              {id: 28, name: "Science Fiction"}]
    } }

  describe '.top_movies' do
    it 'gets the top 40 movies' do
      movie_data = Array.new(40, movie_info)
      allow(MovieDbService).to receive(:top_movies).and_return(movie_data)

      top_movies = MoviesFacade.top_movies

      expect(top_movies).to be_an(Array)
      expect(top_movies[0]).to be_a(MovieProxy)
      expect(top_movies.size).to eq(40)
    end
  end

  describe '.search_movies' do
    it 'gets up to 40 movies matching a search phrase' do
      movie_data = Array.new(40, movie_info)
      allow(MovieDbService).to receive(:search_movies).and_return(movie_data)

      found_movies = MoviesFacade.search_movies("Shawshank")

      expect(found_movies).to be_an(Array)
      expect(found_movies[0]).to be_a(MovieProxy)
    end
  end

  describe '.movie_details' do
    it 'gets details for the specified movie' do
      movie_details = movie_info
      allow(MovieDbService).to receive(:movie_details).and_return(movie_details)
      movie = MoviesFacade.movie_details(324857)

      expect(movie).to be_a(MovieProxy)
    end
  end

  describe '.cast_details' do
    it 'gets the cast for the specified movie' do
      cast_info = {cast: [{name: "Will Smith", character: "Capt. Steven Hiller"},
                          {name: "Jeff Goldblum", character: "David Levinson"}]}
      allow(MovieDbService).to receive(:cast_details).and_return(cast_info)

      cast = MoviesFacade.cast_details(324857)

      expect(cast).to be_an(Array)
      expect(cast[0]).to be_an(Actor)
    end
  end

  describe '.review_details' do
    it 'gets reviews for the specified movie' do
      review_info = [ {author: "GeneSiskel", content: "Amazing!"},
                      {author: "RogerEbert", content: "Explosive!"}]
      allow(MovieDbService).to receive(:review_details).and_return(review_info)

      reviews = MoviesFacade.review_details(324857)

      expect(reviews).to be_an(Array)
      expect(reviews[0]).to be_a(Review)
    end
  end
end

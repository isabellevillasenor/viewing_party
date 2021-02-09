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
end

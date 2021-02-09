class MoviesFacade
  class << self
    def conn
      @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
    end

    def top_movies
      results = MovieDbService.top_movies
      results.map do |result|
        MovieProxy.new(result)
      end
    end

    def search_movies(search_phrase)
      results = MovieDbService.search_movies(search_phrase)
      results.map do |result|
        MovieProxy.new(result)
      end
    end

    def movie_details(movie_id)
      results = MovieDbService.movie_details(movie_id)
      MovieProxy.new(results)
    end

    def cast_details(movie_id)
      results = MovieDbService.cast_details(movie_id)
      results[:cast][0..9].map do |actor|
        Actor.new(actor)
      end
    end

    def review_details(movie_id)
      results = MovieDbService.review_details(movie_id)
      results.map do |result|
        Review.new(result)
      end
    end
  end
end

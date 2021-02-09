class MoviesFacade
  class << self
    def conn
      @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
    end

    def top_movies
      combined_results = MovieDbService.top_movies
      combined_results.map do |result|
        MovieProxy.new(result)
      end
    end

    def search_movies(search_phrase)
      combined_results = MovieDbService.search_movies(search_phrase)
      combined_results.map do |result|
        MovieProxy.new(result)
      end
    end

    def movie_details(movie_id)
      response = conn.get("movie/#{movie_id}?api_key=#{ENV['TMDB_API_KEY']}")
      json = JSON.parse(response.body, symbolize_names: true)
      MovieProxy.new(json)
    end

    def cast_details(movie_id)
      response = conn.get("movie/#{movie_id}/credits?api_key=#{ENV['TMDB_API_KEY']}")
      json = JSON.parse(response.body, symbolize_names: true)
      json[:cast][0..9].map do |actor|
        Actor.new(actor)
      end
    end

    def review_details(movie_id)
      response = conn.get("movie/#{movie_id}/reviews?api_key=#{ENV['TMDB_API_KEY']}")
      json = JSON.parse(response.body, symbolize_names: true)
      if json[:total_pages] > 1
        combined_results = json[:results]
        (json[:total_pages] - 1).times do |index|
          response2 = conn.get("movie/#{movie_id}/reviews?api_key=#{ENV['TMDB_API_KEY']}&page=#{index + 2}")
          json2 = JSON.parse(response2.body, symbolize_names: true)
          combined_results = combined_results + json2[:results]
        end
      else
        combined_results = json[:results]
      end

      combined_results.map do |result|
        Review.new(result)
      end
    end
  end
end

class MovieDbService
  class << self
    def top_movies
      response = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}")
      response2 = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}&page=2")
      json = JSON.parse(response.body, symbolize_names: true)
      json2 = JSON.parse(response2.body, symbolize_names: true)

      json[:results] + json2[:results]
    end

    def search_movies(search_phrase)
      response = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{search_phrase.parameterize}")
      json = JSON.parse(response.body, symbolize_names: true)

      if json[:total_pages] > 1
        response2 = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{search_phrase.parameterize}&page=2")
        json2 = JSON.parse(response2.body, symbolize_names: true)
        json[:results] + json2[:results]
      else
        json[:results]
      end
    end

    def movie_details(movie_id)
      response = conn.get("movie/#{movie_id}?api_key=#{ENV['TMDB_API_KEY']}")
      JSON.parse(response.body, symbolize_names: true)
    end

    def cast_details(movie_id)
      response = conn.get("movie/#{movie_id}/credits?api_key=#{ENV['TMDB_API_KEY']}")
      JSON.parse(response.body, symbolize_names: true)
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
        combined_results
      else
        json[:results]
      end
    end

    private

    def conn
      @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
    end
  end
end

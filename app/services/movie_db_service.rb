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
        combined_results = json[:results] + json2[:results]
      else
        combined_results = json[:results]
      end
    end

    private

    def conn
      @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
    end
  end
end

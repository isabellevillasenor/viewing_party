class MovieDbService
  class << self
    def top_movies
      page1 = get_data('movie/top_rated?')
      page2 = get_data('movie/top_rated?', '&page=2')
      page1[:results] + page2[:results]
    end

    def search_movies(search_phrase)
      page1 = get_data("search/movie?query=#{search_phrase.parameterize}&")
      if page1[:total_pages] > 1
        page2 = get_data("search/movie?query=#{search_phrase.parameterize}&", 2)
        page1[:results] += page2[:results]
      else
        page1[:results]
      end
    end

    def movie_details(movie_id)
      get_data("movie/#{movie_id}?")
    end

    def cast_details(movie_id)
      get_data("movie/#{movie_id}/credits?")
    end

    def review_details(movie_id)
      page1 = get_data("movie/#{movie_id}/reviews?")
      if page1[:total_pages] > 1
        (page1[:total_pages] - 1).times do |index|
          new_page = get_data("movie/#{movie_id}/reviews?", index + 2)
          page1[:results] += new_page[:results]
        end
      end
      page1[:results]
    end

    private

    def get_data(url, page = nil)
      response = conn.get("#{url}api_key=#{ENV['TMDB_API_KEY']}#{"&page=#{page}" if page}")
      JSON.parse(response.body, symbolize_names: true)
    end

    def conn
      @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
    end
  end
end

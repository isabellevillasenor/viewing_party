class MoviesController < ApplicationController
  def index
    @movies = get_movies
    #
  end

  def discover
  end


  private
  def get_movies
    conn = Faraday.new(url: "https://api.themoviedb.org")
    response = conn.get("/3/movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}")
    response2 = conn.get("/3/movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}&page=2")

    json = JSON.parse(response.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)

    combined_results = json[:results] + json2[:results]

    combined_results.map do |result|
      MovieProxy.new(result)
    end
  end
end

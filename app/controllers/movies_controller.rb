class MoviesController < ApplicationController
  def index
    if params[:title]
      @movies = search_movies
    else
      @movies = get_movies
    end
  end

  def discover
  end


  private
  def conn
    @conn ||= Faraday.new(url: "https://api.themoviedb.org/3")
  end

  def get_movies
    response = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}")
    response2 = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}&page=2")
    json = JSON.parse(response.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)

    combined_results = json[:results] + json2[:results]

    combined_results.map do |result|
      MovieProxy.new(result)
    end
  end

  def search_movies
    response = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{params[:title].parameterize}")
    json = JSON.parse(response.body, symbolize_names: true)
    
    if json[:total_pages] > 1
      response2 = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{params[:title].parameterize}&page=2")
      json2 = JSON.parse(response2.body, symbolize_names: true)
      combined_results = json[:results] + json2[:results]
    else
      combined_results = json[:results]
    end

    combined_results.map do |result|
      MovieProxy.new(result)
    end
  end
end

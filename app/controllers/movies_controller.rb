class MoviesController < ApplicationController
  def index
    @movies = if params[:title]
                search_movies
              elsif params[:q]
                top_movies
              end
  end

  def show
    @movie = movie_details
    @cast = cast_details
    @reviews = review_details
  end

  private

  def conn
    @conn ||= Faraday.new(url: 'https://api.themoviedb.org/3')
  end

  # def top_movies
  #   response = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}")
  #   response2 = conn.get("movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}&page=2")
  #   json = JSON.parse(response.body, symbolize_names: true)
  #   json2 = JSON.parse(response2.body, symbolize_names: true)
  #
  #   combined_results = json[:results] + json2[:results]
  #
  #   combined_results.map do |result|
  #     MovieProxy.new(result)
  #   end
  # end

  # def search_movies
  #   response = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{params[:title].parameterize}")
  #   json = JSON.parse(response.body, symbolize_names: true)
  #
  #   if json[:total_pages] > 1
  #     response2 = conn.get("search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{params[:title].parameterize}&page=2")
  #     json2 = JSON.parse(response2.body, symbolize_names: true)
  #     combined_results = json[:results] + json2[:results]
  #   else
  #     combined_results = json[:results]
  #   end
  #
  #   combined_results.map do |result|
  #     MovieProxy.new(result)
  #   end
  # end

  def movie_details
    response = conn.get("movie/#{params[:id]}?api_key=#{ENV['TMDB_API_KEY']}")
    json = JSON.parse(response.body, symbolize_names: true)
    MovieProxy.new(json)
  end

  def cast_details
    response = conn.get("movie/#{params[:id]}/credits?api_key=#{ENV['TMDB_API_KEY']}")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:cast][0..9].map do |actor|
      Actor.new(actor)
    end
  end

  def review_details
    response = conn.get("movie/#{params[:id]}/reviews?api_key=#{ENV['TMDB_API_KEY']}")
    json = JSON.parse(response.body, symbolize_names: true)
    if json[:total_pages] > 1
      combined_results = json[:results]
      (json[:total_pages] - 1).times do |index|
        response2 = conn.get("movie/#{params[:id]}/reviews?api_key=#{ENV['TMDB_API_KEY']}&page=#{index + 2}")
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

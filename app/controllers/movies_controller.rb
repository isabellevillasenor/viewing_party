class MoviesController < ApplicationController
  def index
    @movies = if params[:title]
                MoviesFacade.search_movies(params[:title])
              elsif params[:q]
                MoviesFacade.top_movies
              end
  end

  def show
    @movie = MoviesFacade.movie_details(params[:api_ref])
    @cast = MoviesFacade.cast_details(params[:api_ref])
    @reviews = MoviesFacade.review_details(params[:api_ref])
    session[:movie] = {
      title: @movie.title,
      runtime: @movie.runtime,
      id: @movie.api_ref
    }
  end
end

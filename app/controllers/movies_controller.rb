class MoviesController < ApplicationController
  def index
    @movies = if params[:title]
                MoviesFacade.search_movies(params[:title])
              elsif params[:q]
                MoviesFacade.top_movies
              end
  end

  def show
    @movie = MoviesFacade.movie_details(params[:id])
    @cast = MoviesFacade.cast_details(params[:id])
    @reviews = MoviesFacade.review_details(params[:id])
  end
end

class MoviesController < ApplicationController
  def showing
    @movies = Movie.now_playing
  end

  def upcoming
    @movies = Movie.upcoming
  end

  def show
    @movie = Movie.find(params[:id])
  end
end

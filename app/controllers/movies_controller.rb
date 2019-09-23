class MoviesController < ApplicationController
  def upcoming
    @movies = Movie.now_playing
  end
end

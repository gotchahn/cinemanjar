class MoviesController < ApplicationController

  def index
    if params[:mode] == "upcoming"
      @movies = cache_movie_collection(:upcoming)
    else
      @movies = cache_movie_collection(:now_playing)
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @cast = @movie.cast
    @videos = @movie.videos
    @similars = @movie.similar_movies.shuffle.first(4)
  end

  protected

  def cache_movie_collection(collection_method)
    expires_in = DateTime.now.end_of_day.hour - DateTime.now.hour
    Rails.cache.fetch(collection_method.to_s, expires_in: expires_in.hour) do
      Movie.public_send(collection_method)
    end
  end
end

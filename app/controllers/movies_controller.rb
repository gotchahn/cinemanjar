class MoviesController < ApplicationController

  def index
    if params[:mode] == "upcoming"
      @movies = cache_movie_collection(:upcoming)
    else
      @movies = cache_movie_collection(:now_playing)
    end
  end

  def show
    @movie = Rails.cache.fetch("movie/#{params[:id]}") do
      Movie.find(params[:id])
    end
    @cast = @movie.cast
    @videos = @movie.videos
    @similars = @movie.similar_movies.shuffle.first(4)
    @showtimes = filter_shows_by_movie_id(@movie.imdb_id)
  end

  protected

  def cache_movie_collection(collection_method)
    expires_in = DateTime.now.end_of_day.hour - DateTime.now.hour
    Rails.cache.fetch(collection_method.to_s, expires_in: expires_in.hour) do
      Movie.public_send(collection_method)
    end
  end

  def filter_shows_by_movie_id(imdb_id)
    return [] unless current_account.favorite_cinema

    mg_cinema = current_account.favorite_cinema.to_movie_glu_cinema
    showtimes = mg_cinema.now_playing
    showtimes.select{ |showtime| showtime.web_imdb_id == imdb_id }.first
  end
end

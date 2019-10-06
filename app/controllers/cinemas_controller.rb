class CinemasController < ApplicationController

  def index

    if current_account.address.blank? || !current_account.address.geocoded?
      flash[:error] = "You need to set a valid address."
      redirect_to account_path
    end

    cinemas = Rails.cache.fetch(cache_key, expires_in: 1.month) do
      MovieGluCinema.nearby(current_account, 10)
    end

    @favorite_cinema = current_account.favorite_cinema
    @cinemas_without_fav = cinemas.delete_if{ |cine| cine.cinema_id == @favorite_cinema.try(:movie_glu_cinema_id)}
  end

  def show
    cinema_id = params[:id]
    @cinema = Rails.cache.fetch("cinemaDetails/#{cinema_id}", expires_in: 6.month) do
      MovieGluCinema.find(cinema_id, current_account.address.latlng)
    end

    @now_playing = @cinema.now_playing
    inject_tmdb_movie_id
  end

  protected

    def cache_key
      # lat;lng;nearby
      "#{current_account.address.latlng};nearby"
    end

    def inject_tmdb_movie_id
      @now_playing.each do |movie|
        movie.tmdb_movie = Movie.find_by_imdb_id(movie.web_imdb_id)
      end
    end
end

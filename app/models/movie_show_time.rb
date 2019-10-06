class MovieShowTime
  include Parseable

  attr_accessor :film_id, :imdb_id, :film_name, :age_rating, :images,
    :showings, :tmdb_movie

  def web_imdb_id
    "tt#{imdb_id}"
  end
end

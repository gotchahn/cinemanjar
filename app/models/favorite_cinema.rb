class FavoriteCinema < ApplicationRecord
  has_many :accounts

  def to_movie_glu_cinema
    MovieGluCinema.new({
        "cinema_id" => movie_glu_cinema_id,
        "cinema_name" => name
    })
  end
end

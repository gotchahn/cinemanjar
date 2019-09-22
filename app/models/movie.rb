class Movie < TheMovieDbApi
  attr_accessor :id, :imdb_id, :poster_path, :overview, :title, :release_date,
    :popularity, :original_language, :runtime, :homepage

  #has_many :genres

  def self.find(movie_id)
    response = get("movie/#{movie_id}")

    if response.success?
      new(response.body)
    end
  end

  def self.now_playing
    response = get("movie/now_playing")

    if response.success?
      source_to_collection(response.body["results"])
    else
      []
    end
  end

  def self.upcoming
    response = get("movie/upcoming")

    if response.success?
      source_to_collection(response.body["results"])
    else
      []
    end
  end

  def similar_movies
    return [] unless id
    response = self.class.get("movie/#{id}/similar")

    if response.success?
      self.class.source_to_collection(response.body["results"])
    else
      []
    end
  end

  def poster_url
    "https://image.tmdb.org/t/p/w300#{poster_path}"
  end
end

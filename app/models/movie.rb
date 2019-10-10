class Movie < TheMovieDbApi
  attr_accessor :id, :imdb_id, :poster_path, :overview, :title, :release_date,
    :popularity, :original_language, :runtime, :homepage, :genres, :vote_average,
    :genre_ids

  def self.find(movie_id)
    response = get("movie/#{movie_id}")

    if response.success?
      new(response.body)
    end
  end

  def self.find_by_imdb_id(imdb_id)
    params = {
      external_source: "imdb_id"
    }
    response = get("find/#{imdb_id}", params)

    if response.success?
      if response.body["movie_results"].any?
        new(response.body["movie_results"].first)
      end
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

  def cast
    response = self.class.get("movie/#{id}/credits")

    if response.success?
      self.class.source_to_collection(response.body["cast"], Actor)
    else
      []
    end
  end

  def similar_movies
    response = self.class.get("movie/#{id}/similar")

    if response.success?
      self.class.source_to_collection(response.body["results"])
    else
      []
    end
  end

  def videos
    response = self.class.get("movie/#{id}/videos")

    if response.success?
      self.class.source_to_collection(response.body["results"], Video)
    else
      []
    end
  end

  def poster_url
    "https://image.tmdb.org/t/p/w500/#{poster_path}"
  end

  def imdb_url
    "https://www.imdb.com/title/#{imdb_id}/"
  end

  def raitings
    rts = Raitings.all(imdb_id) || []
    unless vote_average == 0
      rts.push(
        {
          "Source" => "The Movie DB",
          "Value" => "#{vote_average}/10"
        }
      )
    end
    rts
  end

  def released?
    DateTime.now >= release_date.to_date
  end

  def genres_txt
    genres.map{ |genre| genre["name"]}.join(", ")
  end
end

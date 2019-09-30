class Actor
  include Parseable

  attr_accessor :name, :character, :profile_path, :imdb_id

  def image_url
    "https://image.tmdb.org/t/p/w200/#{profile_path}"
  end

  def imdb_url
    "https://www.imdb.com/name/#{imdb_id}/"
  end
end

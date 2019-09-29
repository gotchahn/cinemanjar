class Video
  include Parseable
  attr_accessor :key, :site, :type

  def youtube?
    site == "YouTube"
  end

  def trailer?
    type == "Trailer"
  end

  def youtube_embeded_url
    return "" unless youtube?
    "https://www.youtube.com/embed/#{key}?rel=0&autoplay=0"
  end
end

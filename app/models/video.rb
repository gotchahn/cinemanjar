class Video
  include Parseable
  attr_accessor :key, :site, :type

  def youtube?
    type == "YouTube"
  end

  def youtube_url
    return "" unless youtube?
    "https://www.youtube.com/watch?v=#{key}"
  end
end

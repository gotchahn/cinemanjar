module MoviesHelper
  def youtube_trailer(video_collection)
    trailers = video_collection.select{ |video| video.youtube? && video.trailer? }
    trailers.first
  end
end

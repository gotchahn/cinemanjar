module MoviesHelper
  def youtube_trailer(video_collection)
    trailers = video_collection.select{ |video| video.youtube? && video.trailer? }
    trailers.first
  end

  def movie_pick_put_params(movie, time, cinema, date= nil)
    {
      movie_pick: {
        movie_id: movie.id,
        start_time: time["start_time"],
        end_time: time["end_time"],
        movie_picked_at: date,
        cinema_name: cinema.name
      }
    }
  end
end

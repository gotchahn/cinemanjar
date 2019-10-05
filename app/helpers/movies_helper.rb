module MoviesHelper
  def youtube_trailer(video_collection)
    trailers = video_collection.select{ |video| video.youtube? && video.trailer? }
    trailers.first
  end

  def movie_pick_put_params(movie, time)
    {
      movie_pick: {
        movie_id: movie.id,
        movie_name: movie.title,
        start_time: time["start_time"],
        end_time: time["end_time"],
        genres: movie.genres_txt
      }
    }
  end
end

class MoviePick < ApplicationRecord
  belongs_to :account

  validates_presence_of :movie_id, :movie_name

  def self.picked_show_time?(movie_id, start_time, end_time, date=Date.current)
    filter = where(movie_id: movie_id)
      .where(start_time: start_time)
      .where(end_time: end_time)
      .where(movie_picked_at: date)
    filter.first.present?
  end
end

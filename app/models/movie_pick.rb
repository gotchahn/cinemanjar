class MoviePick < ApplicationRecord
  belongs_to :account

  validate_presence_of :movie_id, :movie_name
end

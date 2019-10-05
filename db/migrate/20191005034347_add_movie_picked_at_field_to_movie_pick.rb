class AddMoviePickedAtFieldToMoviePick < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_picks, :movie_picked_at, :datetime
  end
end

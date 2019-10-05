class AddCinemaNameFieldToMoviePick < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_picks, :cinema_name, :text
  end
end

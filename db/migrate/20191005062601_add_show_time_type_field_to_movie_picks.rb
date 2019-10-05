class AddShowTimeTypeFieldToMoviePicks < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_picks, :show_time_type, :text
  end
end

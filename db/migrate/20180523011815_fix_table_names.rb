class FixTableNames < ActiveRecord::Migration
  def change
    rename_table :places_wished, :wished_places
    rename_table :places_been, :visited_places
  end
end

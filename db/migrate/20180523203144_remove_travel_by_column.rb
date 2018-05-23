class RemoveTravelByColumn < ActiveRecord::Migration
  def change
    remove_column :wished_places, :travel_by 
  end
end

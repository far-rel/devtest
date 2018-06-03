class CreateJoinTableLocationGroupLocation < ActiveRecord::Migration[5.2]
  def change
    create_join_table :locations, :location_groups do |t|
      t.index %i[location_id location_group_id], name: :index_location_location_group
      t.index %i[location_group_id location_id], name: :index_location_group_location
    end
  end
end

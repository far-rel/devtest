class CreateJoinTableTargetGroupCountry < ActiveRecord::Migration[5.2]
  def change
    create_join_table :countries, :target_groups do |t|
      t.index %i[country_id target_group_id], name: :index_country_target_group
      t.index %i[target_group_id country_id], name: :index_target_group_country
    end
  end
end

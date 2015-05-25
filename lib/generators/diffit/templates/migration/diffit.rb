class Create<%= class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.string :table_name, null: false
      t.integer :record_id, null: false
      t.string :column_name, null: false
      t.datetime :changed_at, null: false
      t.hstore :value, null: false
    end

    add_index :<%= table_name %>, :changed_at
    add_index :<%= table_name %>, [:table_name, :record_id, :column_name], unique: true
  end
end

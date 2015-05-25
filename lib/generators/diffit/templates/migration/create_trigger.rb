class CreateDiffit<%= class_name %>Trigger < ActiveRecord::Migration
  def up
    execute %[
      CREATE TRIGGER diffit_<%= table_name %>_trigger
      AFTER INSERT OR UPDATE OR DELETE ON <%= table_name %>
      FOR EACH ROW
      EXECUTE PROCEDURE diffit_changes();
    ]
  end

  def down
    execute %[
      DROP TRIGGER diffit_<%= table_name %>_trigger;
    ]
  end
end

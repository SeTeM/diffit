class AddDiffTriggerAndFuncTo<%= class_name %> < ActiveRecord::Migration
  def up
    execute %[
      CREATE OR REPLACE RULE "insert_or_update_to_#{table_name}" AS
      ON INSERT TO
        #{table_name}
      WHERE EXISTS
        ( SELECT 1
          FROM #{diffit_table_name}
          WHERE
            table_name = NEW.table_name AND
            record_id = NEW.record_id AND
            column_name = NEW.column_name)
      DO INSTEAD NOTHING;

      CREATE FUNCTION diff_#{table_name}_fun(record_id int, column_name string)
      BEGIN
        INSERT INTO #{diffit_table_name} (table_name, record_id, column_name, changed_at)
        VALUES (#{table_name}, record_id, #{column_name}, current_time);
      END;

      CREATE TRIGGER diff_<%= table_name %>_trigger
      AFTER INSERT OR UPDATE OR DELETE ON <%= table_name %>
      FOR EACH ROW
      EXECUTE PROCEDURE diff_<%= table_name %>_fun();
    ]
  end

  def down
    execute %[
      DROP FUNCTION diff_<%= function_name %>_fun;
      DROP TRIGGER diff_<%= function_name %>_trigger;
    ]
  end
end

class Create<%= class_name %> < ActiveRecord::Migration
  def up
    create_table :<%= table_name %> do |t|
      t.string :table_name, null: false
      t.integer :record_id, null: false
      t.datetime :changed_at, null: false
      t.string :column_name, null: false
      t.text :value
    end

    add_index :<%= table_name %>, :changed_at
    add_index :<%= table_name %>, [:table_name, :record_id, :column_name], unique: true

    execute %[
      CREATE OR REPLACE FUNCTION diffit_changes()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS
      $BODY$

      DECLARE
          ri RECORD;
          oldValue TEXT;
          newValue TEXT;
          isColumnSignificant BOOLEAN;
          isValueModified BOOLEAN;
          changedAt TIMESTAMP;
      BEGIN
          IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
              changedAt := current_timestamp;

              FOR ri IN
                  -- Fetch a ResultSet listing columns defined for this trigger's table.
                  SELECT ordinal_position, column_name, data_type
                  FROM information_schema.columns
                  WHERE
                      table_schema = quote_ident(TG_TABLE_SCHEMA)
                  AND table_name = quote_ident(TG_TABLE_NAME)
                  ORDER BY ordinal_position
              LOOP
                  -- For each column in this trigger's table, copy the OLD & NEW values into respective variables.
                  -- NEW value
                  EXECUTE 'SELECT ($1).' || ri.column_name || '::text' INTO newValue USING NEW;
                  -- OLD value
                  IF (TG_OP = 'INSERT') THEN   -- If operation is an INSERT, we have no OLD value, so use an empty string.
                      oldValue := ''::varchar;
                  ELSE   -- Else operation is an UPDATE, so capture the OLD value.
                      EXECUTE 'SELECT ($1).' || ri.column_name || '::text' INTO oldValue USING OLD;
                  END IF;

                  isColumnSignificant := ri.column_name NOT IN ('id', 'created_at', 'updated_at');
                  IF isColumnSignificant THEN
                      isValueModified := oldValue <> newValue;
                      IF isValueModified OR isValueModified IS NULL THEN
                          INSERT INTO diffits ( table_name, record_id, column_name, value, changed_at )
                          VALUES ( TG_TABLE_NAME, NEW.id, ri.column_name::VARCHAR, newValue, changedAt );
                      END IF;
                  END IF;
              END LOOP;

              RETURN NEW;
          ELSIF (TG_OP = 'DELETE') THEN
              INSERT INTO diffits ( table_name, record_id, column_name, value, changed_at)
              VALUES ( TG_TABLE_NAME, NEW.id, ri.column_name::VARCHAR, ''::TEXT, changedAt );
              RETURN OLD;
          END IF;
      END;

      $BODY$;
    ]

    execute %[
      CREATE OR REPLACE RULE "insert_or_update_to_<%= table_name %>" AS ON INSERT TO <%= table_name %>
      WHERE EXISTS
        ( SELECT 1
          FROM <%= table_name %>
          WHERE
            table_name = NEW.table_name AND
            record_id = NEW.record_id AND
            column_name = NEW.column_name )
      DO INSTEAD
        UPDATE <%= table_name %>
        SET changed_at = NEW.changed_at, value = NEW.value
        WHERE
          table_name = NEW.table_name AND
          record_id = NEW.record_id AND
          column_name = NEW.column_name;
    ]
  end

  def down
    execute %[
      DROP RULE insert_or_update_to_<%= table_name %> ON <%= table_name %>;
      DROP FUNCTION diffit_changes;
    ]
    drop_table :<%= table_name %>
  end
end

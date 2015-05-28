class Create<%= class_name %> < ActiveRecord::Migration
  def up
    enable_extension "hstore"

    create_table :<%= table_name %> do |t|
      t.string :table_name, null: false
      t.integer :record_id, null: false
      t.datetime :last_changed_at, null: false
      t.hstore :values
    end

    add_index :<%= table_name %>, :last_changed_at
    add_index :<%= table_name %>, [:table_name, :record_id], unique: true

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
          valuesHsore HSTORE;
      BEGIN
          changedAt := current_timestamp;
          valuesHsore := ''::HSTORE;

          FOR ri IN
              SELECT ordinal_position, column_name, data_type
              FROM information_schema.columns
              WHERE
                  table_schema = quote_ident(TG_TABLE_SCHEMA)
              AND table_name = quote_ident(TG_TABLE_NAME)
              ORDER BY ordinal_position
          LOOP
              -- NEW value
              IF (TG_OP = 'DELETE') THEN
                  newValue := ''::VARCHAR;
              ELSE
                  EXECUTE 'SELECT ($1).' || ri.column_name || '::text' INTO newValue USING NEW;
              END IF;

              -- OLD value
              IF (TG_OP = 'INSERT') THEN   -- If operation is an INSERT, we have no OLD value, so use an empty string.
                  oldValue := ''::VARCHAR;
              ELSE   -- Else operation is an UPDATE, so capture the OLD value.
                  EXECUTE 'SELECT ($1).' || ri.column_name || '::text' INTO oldValue USING OLD;
              END IF;

              isColumnSignificant := ri.column_name NOT IN ('id', 'created_at', 'updated_at');
              IF isColumnSignificant THEN
                  isValueModified := (oldValue <> newValue) OR (oldValue IS NOT NULL AND newValue IS NULL) OR (oldValue IS NULL AND newValue IS NOT NULL);
                  IF isValueModified THEN
                      valuesHsore := valuesHsore || hstore(ri.column_name::VARCHAR, changedAt::TEXT);
                  END IF;
              END IF;

              IF valuesHsore <> ''::HSTORE THEN
                  INSERT INTO diffits ( table_name, record_id, values, last_changed_at )
                  VALUES ( TG_TABLE_NAME, NEW.id, valuesHsore, changedAt );
              END IF;
          END LOOP;

          IF (TG_OP = 'DELETE') THEN
            RETURN OLD;
          ELSE
            RETURN NEW;
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
            record_id = NEW.record_id)
      DO INSTEAD
        UPDATE <%= table_name %>
        SET last_changed_at = NEW.last_changed_at, values = values || NEW.values
        WHERE
          table_name = NEW.table_name AND
          record_id = NEW.record_id;
    ]
  end

  def down
    execute %[
      DROP RULE insert_or_update_to_<%= table_name %> ON <%= table_name %>;
      DROP FUNCTION diffit_changes;
    ]
    remove_index :<%= table_name %>, :last_changed_at
    remove_index :<%= table_name %>, [:table_name, :record_id]
    drop_table :<%= table_name %>
  end
end

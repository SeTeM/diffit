class CreateDiffitUsersTrigger < ActiveRecord::Migration
  def up
    execute %[
      CREATE TRIGGER diffit_users_trigger
      AFTER INSERT OR UPDATE OR DELETE ON users
      FOR EACH ROW
      EXECUTE PROCEDURE diffit_changes();
    ]
  end

  def down
    execute %[
      DROP TRIGGER diffit_users_trigger;
    ]
  end
end

module ActsAsStatusChangeable
  class Migration < ActiveRecord::Migration

    def up
      create_status_changes_table

      # TODO leave default names for indices except when testing the gem itself
      add_index :status_changes, :status, :name => "index_aasc_s"
      add_index :status_changes, [:status_changeable_id, :status_changeable_type], :name => "index_aasc_sci_sct"
    end

    def down
      drop_status_changes_table
    end

    def create_status_changes_table
      create_table :status_changes do |t|
        t.integer :status_changeable_id, :null => false
        t.string  :status_changeable_type, :null => false
        t.string  :status_name, :null => false
        t.string  :status
        t.timestamps
      end

    end

    def drop_status_changes_table
      drop_table :status_changes
    end

  end
end


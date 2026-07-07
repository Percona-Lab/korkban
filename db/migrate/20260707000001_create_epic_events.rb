class CreateEpicEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :epic_events do |t|
      t.integer :epic_id
      t.string :jira_key, null: false
      t.string :name, null: false
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false

      t.timestamps
    end
    add_index :epic_events, :occurred_at
    add_index :epic_events, :jira_key
  end
end

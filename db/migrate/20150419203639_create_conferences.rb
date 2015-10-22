class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.integer :creator_user_id, null: false
      t.date :starting_at, null: false
      t.date :ending_at, null: false
      t.date :allow_starting_at, null: false
      t.date :allow_ending_at, null: false
      t.integer :year, null: false
      t.timestamps null: false
    end

    add_foreign_key :conferences, :users, column: :creator_user_id
    add_index :conferences, [:year], unique: true

    change_table :events do |t|
      t.integer :conference_id
    end

    add_foreign_key :events, :conferences

    change_column_null :events, :conference_id, false

    # Backport the timestamps null: false to other tables
    change_column_null :users, :created_at, false
    change_column_null :users, :updated_at, false
    change_column_null :events, :created_at, false
    change_column_null :events, :updated_at, false
  end
end

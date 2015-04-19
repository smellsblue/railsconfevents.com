class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :creator_user_id
      t.string :anonymous_user_ip
      t.string :name, null: false
      t.string :coordinator
      t.string :coordinator_twitter
      t.string :url
      t.string :location
      t.text :description
      t.datetime :starting_at, null: false
      t.datetime :ending_at, null: false
      t.boolean :listed, null: false
      t.boolean :deleted, null: false, default: false
      t.timestamp :deleted_at
      t.integer :deleted_by_user_id

      t.timestamps null: true
    end

    add_foreign_key :events, :users, column: :creator_user_id
    add_foreign_key :events, :users, column: :deleted_by_user_id
    add_index :events, [:starting_at]
  end
end

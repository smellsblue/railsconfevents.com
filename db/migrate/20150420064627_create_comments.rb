class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :creator_user_id, null: false
      t.integer :event_id, null: false
      t.text :text, null: false
      t.timestamps null: false
    end

    add_foreign_key :comments, :users, column: :creator_user_id
    add_foreign_key :comments, :events
    add_index :comments, [:event_id, :created_at]

    change_table :events do |t|
      t.integer :comments_count, default: 0, null: false
    end
  end
end

class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.integer :event_id, null: false
      t.timestamps null: false
    end

    add_foreign_key :signups, :events
    add_index :signups, [:event_id]

    create_table :signups_questions do |t|
      t.integer :signup_id, null: false
      t.string :style, null: false
      t.string :description, null: false
      t.text :options, null: false
      t.timestamps null: false
    end

    add_foreign_key :signups_questions, :signups
    add_index :signups_questions, [:signup_id]

    create_table :signups_answers do |t|
      t.integer :answerer_user_id, null: false
      t.integer :signup_id, null: false
      t.integer :signups_question_id
      t.timestamps null: false
    end

    add_foreign_key :signups_answers, :signups
    add_foreign_key :signups_answers, :signups_questions
    add_index :signups_answers, [:signup_id]
    add_index :signups_answers, [:signups_question_id]
    add_index :signups_answers, [:answerer_user_id]
  end
end

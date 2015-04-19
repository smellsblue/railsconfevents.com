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

    railsconf_2015 = Conference.create! do |conference|
      conference.starting_at = Date.strptime "4/21/2015", "%m/%d/%Y"
      conference.ending_at = Date.strptime "4/23/2015", "%m/%d/%Y"
      conference.allow_starting_at = Date.strptime "4/18/2015", "%m/%d/%Y"
      conference.allow_ending_at = Date.strptime "4/26/2015", "%m/%d/%Y"
      conference.year = 2015
      conference.creator_user_id = 1
    end

    change_table :events do |t|
      t.integer :conference_id
    end

    add_foreign_key :events, :conferences

    Event.all.each do |event|
      event.conference_id = railsconf_2015.id
      event.save!
    end

    change_column_null :events, :conference_id, false

    # Backport the timestamps null: false to other tables
    change_column_null :users, :created_at, false
    change_column_null :users, :updated_at, false
    change_column_null :events, :created_at, false
    change_column_null :events, :updated_at, false
  end
end

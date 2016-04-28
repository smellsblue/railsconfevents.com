class CreateCoordinators < ActiveRecord::Migration
  class MigrateEvent < ActiveRecord::Base
    self.table_name = "events"
  end

  class MigrateCoordinator < ActiveRecord::Base
    self.table_name = "coordinators"
  end

  def up
    create_table :coordinators do |t|
      t.integer :event_id, null: false
      t.integer :user_id
      t.string :name
      t.string :twitter
      t.index [:event_id]
    end

    MigrateEvent.reset_column_information
    MigrateCoordinator.reset_column_information

    MigrateEvent.all.each do |event|
      if event.coordinator.present? || event.coordinator_twitter.present?
        MigrateCoordinator.create! event_id: event.id,
                                   name: event.coordinator,
                                   twitter: event.coordinator_twitter
      end
    end

    remove_column :events, :coordinator
    remove_column :events, :coordinator_twitter
  end

  def down
    add_column :events, :coordinator, :string
    add_column :events, :coordinator_twitter, :string

    MigrateEvent.reset_column_information
    MigrateCoordinator.reset_column_information

    MigrateCoordinator.order(id: :desc).each do |coordinator|
      if coordinator.name.present? || coordinator.twitter.present?
        event = MigrateEvent.find(coordinator.event_id)
        event.coordinator = coordinator.name
        event.coordinator_twitter = coordinator.twitter
        event.save!
      end
    end

    drop_table :coordinators
  end
end

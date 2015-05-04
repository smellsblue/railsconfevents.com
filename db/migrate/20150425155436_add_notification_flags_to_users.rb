class AddNotificationFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_email, :boolean, default: false, null: false
    add_column :users, :notify_twitter, :boolean, default: false, null: false
  end
end

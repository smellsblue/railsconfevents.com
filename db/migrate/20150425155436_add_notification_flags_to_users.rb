class AddNotificationFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_email, :boolean, default: false
    add_column :users, :notify_twitter, :boolean, default: false
  end
end

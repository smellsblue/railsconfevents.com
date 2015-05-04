class AddTwitterHandleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_handle, :string, default: ""
  end
end

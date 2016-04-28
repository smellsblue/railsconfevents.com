class AddGithubUsernameToCoordinators < ActiveRecord::Migration
  def change
    add_column :coordinators, :username, :string
  end
end

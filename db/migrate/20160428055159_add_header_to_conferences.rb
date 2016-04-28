class AddHeaderToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :header, :text
  end
end

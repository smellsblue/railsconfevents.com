class AddTimezoneToConference < ActiveRecord::Migration
  def change
    change_table :conferences do |t|
      t.string :timezone
    end

    change_column_null :conferences, :timezone, false
  end
end

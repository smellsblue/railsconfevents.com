class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :avatar
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :remember_token
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: true
    end

    add_index :users, [:provider, :uid], unique: true
  end
end

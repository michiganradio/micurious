class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
    User.update_all("admin = true")
  end
end

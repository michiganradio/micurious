class RemovePasswordConfirmationFromAdmins < ActiveRecord::Migration
  def change
    remove_column :admins, :password_confirmation, :string
  end
end

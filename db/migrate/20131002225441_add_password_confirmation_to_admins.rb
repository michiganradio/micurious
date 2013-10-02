class AddPasswordConfirmationToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :password_confirmation, :string
  end
end

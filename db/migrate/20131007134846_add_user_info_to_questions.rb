class AddUserInfoToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :neighbourhood, :string
    add_column :questions, :name, :string
    add_column :questions, :email, :string
    add_column :questions, :anonymous, :boolean
  end
end

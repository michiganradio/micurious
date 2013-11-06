class AddStatusToQuestionsTable < ActiveRecord::Migration
  def change
    add_column :questions, :status, :string, limit: 50, null: false, default: "New"
    add_index :questions, :status
  end
end

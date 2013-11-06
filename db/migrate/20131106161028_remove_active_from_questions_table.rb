class RemoveActiveFromQuestionsTable < ActiveRecord::Migration
  def change
    remove_column :questions, :active
  end
end

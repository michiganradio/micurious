class AddActiveFlagToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :active, :boolean, default: true, null: false
  end
end

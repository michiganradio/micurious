class ChangeQuestionTextToString < ActiveRecord::Migration
  def change
    change_column :questions, :original_text, :string, :null => false, :limit => 140
    change_column :questions, :display_text, :string, :null => false, :limit => 140
  end
end

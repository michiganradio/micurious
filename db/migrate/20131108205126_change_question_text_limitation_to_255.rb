class ChangeQuestionTextLimitationTo255 < ActiveRecord::Migration
  def change
    change_column :questions, :display_text, :string, null: false
    change_column :questions, :original_text, :string, null:false
  end
end

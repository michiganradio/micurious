class LooseQuestionsTextLength < ActiveRecord::Migration
  def change
    change_column :questions, :display_text, :text, null:false, limit: 1000
    change_column :questions, :original_text, :text, null:false, limit: 1000
  end
end

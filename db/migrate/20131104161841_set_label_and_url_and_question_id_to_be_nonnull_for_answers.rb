class SetLabelAndUrlAndQuestionIdToBeNonnullForAnswers < ActiveRecord::Migration
  def change
    change_column :answers, :label, :string, :null => false
    change_column :answers, :url, :string, :null => false
    change_column :answers, :question_id, :integer, :null => false
  end
end

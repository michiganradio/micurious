class MakeLabelAndUrlAndQuestionIdNotNullInResponses < ActiveRecord::Migration
  def change
    change_column :responses, :label, :string, :null => false
    change_column :responses, :url, :string, :null => false
    change_column :responses, :question_id, :integer, :null => false
    change_column :responses, :type, :string, :null => false
  end
end

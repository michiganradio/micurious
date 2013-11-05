class ChangeResponsesTableNameToAnswers < ActiveRecord::Migration
  def change
    rename_table('responses', 'answers')
  end
end

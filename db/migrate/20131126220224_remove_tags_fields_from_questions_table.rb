class RemoveTagsFieldsFromQuestionsTable < ActiveRecord::Migration
  def change
    remove_column :questions, :tags
    remove_column :questions, :tags_updated_at
  end
end

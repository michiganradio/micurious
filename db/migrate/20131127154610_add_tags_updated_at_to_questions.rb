class AddTagsUpdatedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tags_updated_at, :datetime
  end
end

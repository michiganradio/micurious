class AddTagsUpdatedAtAndNotesUpdatedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tags_updated_at, :datetime
    add_column :questions, :notes_updated_at, :datetime
  end
end

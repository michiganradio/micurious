class AddNotesAndTagsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :notes, :text
    add_column :questions, :tags, :text
  end
end

class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :original_text
      t.text :display_text

      t.timestamps
    end
  end
end

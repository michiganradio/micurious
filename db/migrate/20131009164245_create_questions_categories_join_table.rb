class CreateQuestionsCategoriesJoinTable < ActiveRecord::Migration
  def change
    create_table :questions_categories, id: false do |t|
      t.integer :question_id
      t.integer :category_id
    end
  end
end

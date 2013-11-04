class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :label
      t.string :url
      t.references :question, index: true

      t.timestamps
    end
  end
end

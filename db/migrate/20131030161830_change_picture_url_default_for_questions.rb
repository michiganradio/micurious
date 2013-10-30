class ChangePictureUrlDefaultForQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :picture_url, :string, default: "/assets/default-question-picture.jpg"
  end
end

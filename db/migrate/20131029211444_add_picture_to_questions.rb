class AddPictureToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :picture_url, :string, default: "/default-question-picture.jpg"
    add_column :questions, :picture_owner, :string, default: "Curious City"
  end
end

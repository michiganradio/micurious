class RemovePictureUrlDefaultFromQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :picture_url, :string, default: nil
  end
end

class AddPictureAttributionUrlToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :picture_attribution_url, :string
  end
end

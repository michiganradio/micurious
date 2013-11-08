class AddFeaturedFlagToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :featured, :boolean, default: false
  end
end

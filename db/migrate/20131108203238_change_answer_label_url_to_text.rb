class ChangeAnswerLabelUrlToText < ActiveRecord::Migration
  def change
    change_column :answers, :url, :text, limit: 3000
    change_column :answers, :label, :text, limit: 2000
  end
end

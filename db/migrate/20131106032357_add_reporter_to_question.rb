class AddReporterToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :reporter, :string
  end
end

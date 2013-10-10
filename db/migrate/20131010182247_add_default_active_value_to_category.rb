class AddDefaultActiveValueToCategory < ActiveRecord::Migration
  def change
    change_column :categories, :active, :boolean, :default => true
  end
end

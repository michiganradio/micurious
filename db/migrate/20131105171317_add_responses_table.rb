class AddResponsesTable < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :label, nullable: false
      t.string :url, nullable: false
      t.references :question, index: true, nullable: false
      t.string :type, nullable: false

      t.timestamps
    end
  end
end

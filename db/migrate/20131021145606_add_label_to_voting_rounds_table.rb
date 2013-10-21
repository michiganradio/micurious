class AddLabelToVotingRoundsTable < ActiveRecord::Migration
  def change
    add_column :voting_rounds, :label, :string, limit: 50, unique: true
    add_index :voting_rounds, :label

  end
end

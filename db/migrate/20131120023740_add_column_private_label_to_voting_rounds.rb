class AddColumnPrivateLabelToVotingRounds < ActiveRecord::Migration
  def change
    add_column :voting_rounds, :private_label, :string, limit: 50, unique: true
    add_index :voting_rounds, :private_label
  end
end

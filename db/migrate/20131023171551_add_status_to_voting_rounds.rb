class AddStatusToVotingRounds < ActiveRecord::Migration
  def change
    add_column :voting_rounds, :status, :string, limit: 20, null: false, default: "New"
    add_index :voting_rounds, :status
  end
end

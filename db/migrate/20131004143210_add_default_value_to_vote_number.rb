class AddDefaultValueToVoteNumber < ActiveRecord::Migration
  def change
    change_column :voting_round_questions, :vote_number, :integer, :default => 0, :null => false
  end
end

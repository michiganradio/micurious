class AddDefaultValueToVoteNumber < ActiveRecord::Migration
  def change
    VotingRoundQuestion.update_all({:vote_number => 0})
    change_column :voting_round_questions, :vote_number, :integer, :default => 0, :null => false
  end
end

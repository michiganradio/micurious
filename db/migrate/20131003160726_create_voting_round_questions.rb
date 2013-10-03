class CreateVotingRoundQuestions < ActiveRecord::Migration
  def change
    create_table :voting_round_questions do |t|
      t.integer :voting_round_id
      t.integer :question_id
      t.integer :vote_number

      t.timestamps
    end
  end
end

class VotingRoundQuestion < ActiveRecord::Base
  belongs_to :voting_round
  belongs_to :question
  validates_uniqueness_of :voting_round_id, scope: :question_id, message: "You can not add the question to the same voting round"
end

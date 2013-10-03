class VotingRoundQuestion < ActiveRecord::Base
  belongs_to :voting_round
  belongs_to :question
end

require 'spec_helper'

describe VotingRoundQuestion do
  it { should validate_uniqueness_of(:voting_round_id).scoped_to(:question_id).with_message("You can not add the question to the same voting round")}
end

module Admin::VotingRoundsHelper

  def can_remove_question?
    @voting_round.status == VotingRound::Status::New
  end
end

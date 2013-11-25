module Admin::VotingRoundsHelper

  def can_remove_question?
    @voting_round.status == VotingRound::Status::New
  end

  def convert_time(voting_round_time)
    voting_round_time.nil? ? "" : voting_round_time.strftime("%B, %d, %Y, at %l%P")

  end
end

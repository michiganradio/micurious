module VotingHelper

  def voted?
#   p "cookie vr: " + cookies.permanent[:voting_round_id].to_s
#   p "last vr: " + VotingRound.last.id.to_s
#   p "voted? " + (cookies.permanent[:voting_round_id] == VotingRound.last.id).to_s
    cookies.permanent[:voting_round_id].to_i == VotingRound.last.id.to_i
  end

  def last_vote?(question_id)
    cookies.permanent[:question_id].to_i == question_id.to_i
  end

  def sort_proc
    if voted?
      sort_by_most_votes_proc
    else
      sort_by_id_proc
    end
  end

  private

  def sort_by_most_votes_proc
    #TODO: find_by question_id and voting_round_id
    Proc.new{ |q1, q2| VotingRoundQuestion.find_by(question_id: q2.id).vote_number <=> VotingRoundQuestion.find_by(question_id: q1.id).vote_number }
  end

  def sort_by_id_proc
    Proc.new{ |q1, q2| q1.id <=> q2.id }
  end
end

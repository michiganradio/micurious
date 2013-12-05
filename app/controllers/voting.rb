=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Voting
  def Voting.vote(cookies, params)
    unless (cookies.permanent[:voting_round_id].to_i == VotingRound.last.id.to_i)
      voting_round_question = VotingRoundQuestion.find_by(question_id: params[:question_id], voting_round_id: params[:voting_round_id])
      voting_round_question.vote_number += 1
      voting_round_question.save
      cookies.permanent[:voting_round_id]=VotingRound.last.id
      cookies.permanent[:question_id]=voting_round_question.question_id
      true
    else
      false
    end
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module VotingHelper

  def voted?
    cookies.permanent[:voting_round_id].to_i == VotingRound.last.id.to_i
  end

  def last_vote?(question_id)
    cookies.permanent[:question_id].to_i == question_id.to_i
  end

  def display_order(questions)
    if voted?
      questions.sort &sort_by_most_votes_proc
    else
      questions.shuffle
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

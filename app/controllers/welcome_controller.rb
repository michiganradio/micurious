class WelcomeController < ApplicationController

  def home
    @voting_round = VotingRound.last
  end

  def vote
    voting_round_question = VotingRoundQuestion.find_by(question_id: params[:question_id])
    voting_round_question.vote_number += 1
    voting_round_question.save
    redirect_to root_path
  end

end

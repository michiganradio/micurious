class WidgetController < ApplicationController
  def vote_widget
    @voting_round = VotingRound.last
    @questions = @voting_round.questions[0..2]
    render layout: "widget"
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to vote_widget_path
    else
      render :text=>"Too bad.", status: 409
    end
  end

  def ask_widget
    render layout: "widget"
  end
end

class WidgetController < ApplicationController
  def voting_widget
    @voting_round = VotingRound.last
    @questions = @voting_round.questions[0..2]
    render layout: "widget"
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to voting_widget_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

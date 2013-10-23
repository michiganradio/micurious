class WidgetController < ApplicationController
  def widget
    @voting_round = VotingRound.last
    @questions = @voting_round.questions[0..2]
    render layout: "widget"
  end
end

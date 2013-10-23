class WidgetController < ApplicationController
  def widget
    @questions = VotingRound.last.questions
    render layout: "widget"
  end
end

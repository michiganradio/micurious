require 'voting'

class WidgetController < ApplicationController
  include Voting

  def vote_widget
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
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

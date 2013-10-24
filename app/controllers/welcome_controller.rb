require 'voting'

class WelcomeController < ApplicationController
  include Voting

  def home
    @ask = true
    @categories = Category.all
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to root_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

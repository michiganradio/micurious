require 'voting'

class WelcomeController < ApplicationController
  include Voting
  before_action :load_categories, only: [:home, :about]

  def home
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
  end

  def about
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to root_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

require 'voting'

class VotingRoundsController < ApplicationController
  include Voting
  before_action :load_categories, only: [:home, :about, :show]

  def home
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
    @past_voting_round = @voting_round.get_previous unless @voting_round.nil?
  end

  def about
  end

  def show
    @voting_round = VotingRound.where("id = ?", params[:id]).first
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to root_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

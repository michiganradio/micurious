require 'voting'

class VotingRoundsController < ApplicationController
  include Voting
  before_action :load_categories, only: [:home, :about, :show]

  def home
    @up_for_voting_class = "highlighted"
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
    @previous_voting_round = @voting_round.get_previous unless @voting_round.nil?
  end

  def about

  end

  def show
    @voting_round = VotingRound.where("id = ?", params[:id]).first
    @previous_voting_round = @voting_round.get_previous unless @voting_round.nil?
    if @voting_round.status == VotingRound::Status::Live
      redirect_to root_path
    end
    @next_voting_round = @voting_round.get_next unless @voting_round.nil?
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to root_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

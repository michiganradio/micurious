require 'voting'

class VotingRoundsController < ApplicationController
  include Voting
  before_action :load_categories, only: [:home, :about, :show]

  def home
    @up_for_voting_class = "highlighted"
    @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
    @previous_voting_round = @voting_round.previous unless @voting_round.nil?
  end

  def about

  end

  def show
    @voting_round = VotingRound.where(id: params[:id], status: VotingRound::Status::Completed).first
    redirect_to root_url and return if @voting_round.nil?
    @previous_voting_round = @voting_round.previous
    @next_voting_round = @voting_round.next
  end

  def vote
    if Voting.vote(cookies, params)
      redirect_to root_path
    else
      render :text=>"Too bad.", status: 409
    end
  end
end

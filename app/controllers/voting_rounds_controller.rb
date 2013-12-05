=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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

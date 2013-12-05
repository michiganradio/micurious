=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'voting'

class WidgetController < ApplicationController
  include Voting

  before_action :set_response_header

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

  private

  def set_response_header
    response.headers["X-Frame-Options"] = "ALLOWALL"
  end
end

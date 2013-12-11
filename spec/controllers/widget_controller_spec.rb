=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe WidgetController do

  describe "GET voting widget" do
    it "assigns questions" do
      voting_round = double(:voting_round)
      voting_rounds = [voting_round]
      questions = [double(:question)]
      VotingRound.stub(:where).and_return(voting_rounds)
      get :vote_widget
      assigns(:voting_round).should eq voting_round
      response.headers["X-Frame-Options"].should eq "ALLOWALL"
    end
  end

  describe "POST vote" do
    context "when the vote was legal and successful" do
      it "redirects to root path" do
        Voting.stub(:vote).and_return(true)
        post :vote
        response.should redirect_to(vote_widget_path)
      end
    end

    context "when the vote was illegal and failed" do
      it "renders with status 409" do
        Voting.stub(:vote).and_return(false)
        post :vote
        response.status.should be 409
      end
    end
  end

  describe "GET ask widget" do
    it "gets the ask question widget page" do
      get :ask_widget
      response.status.should be 200
    end
  end
end

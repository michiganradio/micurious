require 'spec_helper'

describe WidgetController do

  describe "GET widget" do
    it "assigns questions" do
      voting_round = [double(:voting_round)]
      questions = [double(:question)]
      VotingRound.stub(:last).and_return(voting_round)
      voting_round.should_receive(:questions).and_return(questions)
      get :widget
      assigns(:questions).should eq questions
      assigns(:voting_round).should eq voting_round
    end
  end
end

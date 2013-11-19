require 'spec_helper'

describe VotingRoundsController do

  describe "GET home" do
    before do
      @voting_round = double(:voting_round)
      VotingRound.stub(:where).with(status: VotingRound::Status::Live).and_return([@voting_round])
      @prev_voting_round = double(:voting_round)
      @voting_round.stub(:previous).and_return(@prev_voting_round)
      subject.stub(:load_categories)
    end

    it "loads the categories" do
      subject.should_receive(:load_categories)
      get :home, {}, {}
    end

    it "assigns active voting round" do
      get :home, {}, {}
      assigns(:voting_round).should eq @voting_round
    end

    it "assigns past voting round" do
      get :home, {}, {}
      assigns(:previous_voting_round).should eq @prev_voting_round
    end
  end
  describe "GET show" do
    context "retrieves voting round that is completed" do
      it "assigns the voting round and redirect to root path" do
      voting_round = double(:voting_round,
                           previous: double(:voting_round),
                           next: double(:voting_round))
      VotingRound.should_receive(:where).with(id: "10", status: VotingRound::Status::Completed).and_return([voting_round])
      get :show, {:id =>10}
      assigns(:voting_round).should eq(voting_round)
      end
    end

    context "voting round is not completed" do
      it "redirects to home page" do
        VotingRound.should_receive(:where).with(id: "10", status: VotingRound::Status::Completed).and_return([])
        get :show, {:id =>10}
        response.should redirect_to(root_url)
      end
    end
  end

  describe "POST vote" do
    context "vote success" do
      it "redirects to root path" do
        Voting.stub(:vote).and_return(true)
        post :vote
        response.should redirect_to(root_path)
      end
    end

    context "vote failure" do
      it "renders with status 409" do
        Voting.stub(:vote).and_return(false)
        post :vote
        response.status.should be 409
      end
    end
  end
end

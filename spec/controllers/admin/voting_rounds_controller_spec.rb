require 'spec_helper'

describe Admin::VotingRoundsController do
  let(:valid_attributes) { { "start_time" => "2013-10-03 11:03:52", "label" => "label text" } }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all voting_rounds as @voting_rounds" do
      voting_round = VotingRound.new(id:1)
      VotingRound.stub(:all).and_return([voting_round])
      get :index, {}, valid_session
      assigns(:voting_rounds).should eq([voting_round])
    end
  end

  describe "GET show" do
    it "assigns the requested voting_round as @voting_round" do
      voting_round = VotingRound.new(id:1)
      VotingRound.stub(:find).and_return(voting_round)
      get :show, {:id => voting_round.to_param}, valid_session
      assigns(:voting_round).should eq(voting_round)
    end
  end

  describe "GET new" do
    it "assigns a new voting_round as @voting_round" do
      get :new, {}, valid_session
      assigns(:voting_round).should be_a_new(VotingRound)
    end
  end

  describe "GET edit" do
    it "assigns the requested voting_round as @voting_round" do
      voting_round = VotingRound.new(id:1)
      VotingRound.stub(:find).and_return(voting_round)
      get :edit, {:id => voting_round.to_param}, valid_session
      assigns(:voting_round).should eq(voting_round)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new VotingRound" do
        voting_round = double(VotingRound)
        VotingRound.should_receive(:new).with(valid_attributes).and_return(voting_round)
        voting_round.should_receive(:save).and_return(true)
        post :create, {:voting_round => valid_attributes}, valid_session
      end

      it "redirects to the voting round index url" do
        voting_round = double(VotingRound)
        VotingRound.stub(:new).and_return(voting_round)
        voting_round.stub(:save).and_return(true)
        post :create, {:voting_round => valid_attributes}, valid_session
        response.should redirect_to(admin_voting_rounds_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved voting_round as @voting_round" do
        VotingRound.any_instance.stub(:save).and_return(false)
        post :create, {:voting_round => { "start_time" => "invalid value" }}, valid_session
        assigns(:voting_round).should be_a_new(VotingRound)
      end

      it "re-renders the 'new' template" do
        VotingRound.any_instance.stub(:save).and_return(false)
        post :create, {:voting_round => { "start_time" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested voting_round" do
        new_attributes = { "start_time" => "2113-10-03 11:03:52", "label" => "new label text"}
        voting_round = VotingRound.new(id: 1)
        VotingRound.stub(:find).and_return(voting_round)
        voting_round.should_receive(:update!).with(new_attributes)
        put :update, {:id => voting_round.to_param, :voting_round => new_attributes}, valid_session
      end

      it "redirects to the voting_round index" do
        voting_round = VotingRound.new(id: 1)
        VotingRound.stub(:find).and_return(voting_round)
        voting_round.stub(:update!)
        put :update, {:id => voting_round.to_param, :voting_round => valid_attributes}, valid_session
        response.should redirect_to(admin_voting_rounds_url)
      end
    end

    describe "with invalid params" do
      it "assigns the voting_round as @voting_round" do
        voting_round = VotingRound.new(id: 1)
        VotingRound.stub(:find).and_return(voting_round)
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRound.any_instance.stub(:update!).and_raise("Error")
        put :update, {:id => voting_round.to_param, :voting_round => { "start_time" => "invalid value" }}, valid_session
        assigns(:voting_round).should eq(voting_round)
      end

      it "re-renders the 'edit' template" do
        voting_round = VotingRound.new(id: 1)
        VotingRound.stub(:find).and_return(voting_round)
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRound.any_instance.stub(:update!).and_raise("Error")
        put :update, {:id => voting_round.to_param, :voting_round => { "start_time" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "add question to voting round" do
    it "saves the voting round question" do
      VotingRoundQuestion.should_receive(:create).with(voting_round_id:"1", question_id:"2")
      put :add_question, {:id => 1, :question_id => 2}
    end
  end

  describe "remove question from voting round" do
    let(:voting_round) { double(VotingRound) }
    let(:voting_round_question) { double(VotingRoundQuestion) }

    before do
      VotingRound.stub(:find).with("1").and_return(voting_round)
      VotingRoundQuestion.stub(:where).with(voting_round_id: "1", question_id: "2").and_return([voting_round_question])
      voting_round_question.stub(:destroy)
      put :remove_question, {:id => 1, :question_id => 2}
    end

    it "assigns the voting round as @voting_round" do
      assigns(:voting_round).should eq voting_round
    end

    it "destroys the voting round question" do
      voting_round_question.should_receive(:destroy)
      put :remove_question, {:id => 1, :question_id => 2}
    end

    it "flashes confirmation" do
      flash.now[:notice].should eq "Question was successfully removed from the voting round"
    end
  end
end

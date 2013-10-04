require 'spec_helper'

describe VotingRoundQuestionsController do
  let(:valid_attributes) { { "voting_round_id" => "1" } }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all voting_round_questions as @voting_round_questions" do
      voting_round_question = VotingRoundQuestion.create! valid_attributes
      get :index, {}, valid_session
      assigns(:voting_round_questions).should eq([voting_round_question])
    end
  end

  describe "GET show" do
    it "assigns the requested voting_round_question as @voting_round_question" do
      voting_round_question = VotingRoundQuestion.create! valid_attributes
      get :show, {:id => voting_round_question.to_param}, valid_session
      assigns(:voting_round_question).should eq(voting_round_question)
    end
  end

  describe "GET new" do
    it "assigns a new voting_round_question as @voting_round_question" do
      get :new, {}, valid_session
      assigns(:voting_round_question).should be_a_new(VotingRoundQuestion)
    end
  end

  describe "GET edit" do
    it "assigns the requested voting_round_question as @voting_round_question" do
      voting_round_question = VotingRoundQuestion.create! valid_attributes
      get :edit, {:id => voting_round_question.to_param}, valid_session
      assigns(:voting_round_question).should eq(voting_round_question)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new VotingRoundQuestion" do
        expect {
          post :create, {:voting_round_question => valid_attributes}, valid_session
        }.to change(VotingRoundQuestion, :count).by(1)
      end

      it "assigns a newly created voting_round_question as @voting_round_question" do
        post :create, {:voting_round_question => valid_attributes}, valid_session
        assigns(:voting_round_question).should be_a(VotingRoundQuestion)
        assigns(:voting_round_question).should be_persisted
      end

      it "redirects to the created voting_round_question" do
        post :create, {:voting_round_question => valid_attributes}, valid_session
        response.should redirect_to(VotingRoundQuestion.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved voting_round_question as @voting_round_question" do
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRoundQuestion.any_instance.stub(:save).and_return(false)
        post :create, {:voting_round_question => { "voting_round_id" => "invalid value" }}, valid_session
        assigns(:voting_round_question).should be_a_new(VotingRoundQuestion)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRoundQuestion.any_instance.stub(:save).and_return(false)
        post :create, {:voting_round_question => { "voting_round_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested voting_round_question" do
        voting_round_question = VotingRoundQuestion.create! valid_attributes
        # Assuming there are no other voting_round_questions in the database, this
        # specifies that the VotingRoundQuestion created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        VotingRoundQuestion.any_instance.should_receive(:update).with({ "voting_round_id" => "1" })
        put :update, {:id => voting_round_question.to_param, :voting_round_question => { "voting_round_id" => "1" }}, valid_session
      end

      it "assigns the requested voting_round_question as @voting_round_question" do
        voting_round_question = VotingRoundQuestion.create! valid_attributes
        put :update, {:id => voting_round_question.to_param, :voting_round_question => valid_attributes}, valid_session
        assigns(:voting_round_question).should eq(voting_round_question)
      end

      it "redirects to the voting_round_question" do
        voting_round_question = VotingRoundQuestion.create! valid_attributes
        put :update, {:id => voting_round_question.to_param, :voting_round_question => valid_attributes}, valid_session
        response.should redirect_to(voting_round_question)
      end
    end

    describe "with invalid params" do
      it "assigns the voting_round_question as @voting_round_question" do
        voting_round_question = VotingRoundQuestion.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRoundQuestion.any_instance.stub(:save).and_return(false)
        put :update, {:id => voting_round_question.to_param, :voting_round_question => { "voting_round_id" => "invalid value" }}, valid_session
        assigns(:voting_round_question).should eq(voting_round_question)
      end

      it "re-renders the 'edit' template" do
        voting_round_question = VotingRoundQuestion.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VotingRoundQuestion.any_instance.stub(:save).and_return(false)
        put :update, {:id => voting_round_question.to_param, :voting_round_question => { "voting_round_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested voting_round_question" do
      voting_round_question = VotingRoundQuestion.create! valid_attributes
      expect {
        delete :destroy, {:id => voting_round_question.to_param}, valid_session
      }.to change(VotingRoundQuestion, :count).by(-1)
    end

    it "redirects to the voting_round_questions list" do
      voting_round_question = VotingRoundQuestion.create! valid_attributes
      delete :destroy, {:id => voting_round_question.to_param}, valid_session
      response.should redirect_to(voting_round_questions_url)
    end
  end

end

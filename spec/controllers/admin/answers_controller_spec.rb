require 'spec_helper'

describe Admin::AnswersController do
  let(:valid_session) { {} }
  before do
    subject.stub(:signed_in_admin)
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      get :new, { question_id: 0 }, valid_session
      assigns(:answer).should be_a_new(Answer)
    end

    it "sets @answer.question_id to given question id" do
      get :new, { question_id: 0 }, valid_session
      assigns(:answer).question_id.should eq 0
    end
  end

  describe "POST create" do
    context "valid answer params" do
      it "creates a new Answer" do
        answer = double(Answer)
        Answer.should_receive(:new).and_return(answer)
        answer.should_receive(:save).and_return(true)
        answer.should_receive(:question_id).and_return(0)
        post :create, { answer: { label: "label", url: "url", question_id: 0, type: Answer::Type::Answer} }, valid_session
      end
    end

    context "invalid answer params" do
      it "assigns a newly created but unsaved answer as @answer" do
        Answer.any_instance.stub(:save).and_return(false)
        post :create, { answer: { label: "label", url: "url" } }, valid_session
        assigns(:answer).should be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        Answer.any_instance.stub(:save).and_return(false)
        post :create, { answer: { label: "label", url: "url" } }, valid_session
        response.should render_template('new')
      end
    end
  end
end

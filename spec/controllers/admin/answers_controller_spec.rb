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
  end

  describe "POST create" do
    it "creates a new Answer" do
      answer = double(Answer)
      Answer.should_receive(:new).and_return(answer)
      answer.should_receive(:save).and_return(true)
      answer.should_receive(:question_id).and_return(0)
      post :create, { answer: { label: "label", url: "url", question_id: 0 } }, valid_session
    end
  end
end

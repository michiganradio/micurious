require 'spec_helper'

describe Admin::AnswersController do
  let(:valid_session) { {} }
  before do
    request.env['HTTPS'] = 'on'
    subject.stub(:signed_in_admin)
  end

  describe "GET index without SSL" do
    it "returns an error" do
      Question.stub(:find).with("0")
      request.env['HTTPS'] = 'off'
      subject.stub(:ssl_configured).and_return(true)
      get :index, { question_id: 0 }, valid_session
      expect(response.status).to eq 301
    end
  end

  describe "GET index" do
    context "no question_id param given" do
      it "raises error" do
        expect {
          get :index, {}, valid_session
        }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context "question_id param given" do
      it "renders 'index' template" do
        Question.stub(:find).with("0")
        get :index, { question_id: 0 }, valid_session
        response.should render_template('index')
      end

      it "assigns @question using question_id" do
        question = double(Question)
        Question.should_receive(:find).with("0").and_return(question)
        get :index, { question_id: 0 }, valid_session
        assigns(:question).should eq question
      end
    end
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

  describe "GET edit" do
    it "renders 'edit' template" do
      answer = double(Answer)
      Answer.stub(:find).with("1").and_return(answer)
      get :edit, { id: 1 }, valid_session
      response.should render_template('edit')
    end

    it "assigns answer from id param as @answer" do
      answer = double(Answer)
      Answer.stub(:find).with("1").and_return(answer)
      get :edit, { id: 1 }, valid_session
      assigns(:answer).should eq answer
    end
  end

  describe "PUT update" do
    context "valid params" do
      it "redirects to answers index for question id param" do
        answer = double(Answer)
        answer.stub(:update_attributes).and_return(true)
        Answer.stub(:find).with("0").and_return(answer)
        put :update, :id => 0, :answer => { :label => "label", :url => "url", :question_id => 0, :type => Answer::Type::Answer }, :session => valid_session
        response.should redirect_to admin_answers_url(question_id: 0)
      end

      it "updates requested answer" do
        answer = double(Answer)
        Answer.should_receive(:find).with("0").and_return(answer)
        answer.should_receive(:update_attributes)
        put :update, :id => 0, :answer => { :label => "label", :url => "url", :question_id => 0, :type => Answer::Type::Answer }, :session => valid_session
      end
    end

    context "invalid params" do
      it "re-renders 'edit template'" do
        answer = double(Answer)
        Answer.stub(:find).with("0").and_return(answer)
        answer.stub(:update_attributes).and_return(false)
        put :update, :id => 0, :answer => { :label => "", :url => "", :question_id => 0, :type => "" }, :session => valid_session
        response.should render_template('edit')
      end
    end
  end

  describe "GET reorder" do
    it "assigns @answers ordered by position using question_id" do
      question = double(Question)
      answers = [double(Answer)]
      Question.should_receive(:find).with("0").and_return(question)
      question.should_receive(:answers).and_return(answers)
      answers.should_receive(:order).and_return(answers)
      get :reorder, { question_id: 0 }, valid_session
      assigns(:answers).should eq answers
    end
  end

  describe "POST sort" do
    it "inserts each answer param in list at param index plus one" do
      answers = [double(Answer), double(Answer), double(Answer)]
      Answer.stub(:find).and_return(answers[0], answers[1], answers[2])
      answers[0].should_receive(:insert_at).with(1)
      answers[1].should_receive(:insert_at).with(2)
      answers[2].should_receive(:insert_at).with(3)
      post :sort, { answer: [5, 6, 7] }, valid_session
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

      it "redirects to answers index for question id param" do
        answer = double(Answer)
        Answer.should_receive(:new).and_return(answer)
        answer.should_receive(:save).and_return(true)
        answer.should_receive(:question_id).and_return(0)
        post :create, { answer: { label: "label", url: "url", question_id: 0, type: Answer::Type::Answer} }, valid_session
        response.should redirect_to admin_answers_url(question_id: 0)
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

    describe "DELETE destroy"do
      it "destroys the requested answer" do
        answer = double(Answer)
        answer.stub(:question_id).and_return(1)
        Question.stub(:find).and_return(double(Question))
        Answer.stub(:find).with("0").and_return(answer)
        answer.should_receive(:destroy)
        delete :destroy, {id: 0}, valid_session
      end

      it "re-renders 'index' template" do
        answer = double(Answer)
        answer.stub(:question_id).and_return(1)
        Question.stub(:find).and_return(double(Question))
        Answer.stub(:find).with("0").and_return(answer)
        answer.stub(:destroy)
        delete :destroy, {id: 0}, valid_session
        response.should render_template('index')
      end
    end
  end
end

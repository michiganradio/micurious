=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Admin::AnswersController do
  let(:valid_session) { {} }
  before do
    request.env['HTTPS'] = 'on'
    subject.stub(:signed_in_admin)
  end

  describe "pages that require preloading of answers and updates" do
    before do
      @question = double(Question)
      @answers = [double(Answer), double(Answer)]
      Question.stub(:find).with("0").and_return(@question)
      @question.stub(:answers).and_return(@answers)
      @answers.stub(:order).and_return(@answers)
      @answers.stub(:where).with(type: Answer::Type::Answer).and_return([@answers[0]])
      @answers.stub(:where).with(type: Answer::Type::Update).and_return([@answers[1]])
    end

    describe "GET index" do
      context "when user is not on SSL" do
        it "returns an error" do
          request.env['HTTPS'] = 'off'
          subject.stub(:ssl_configured).and_return(true)
          get :index, { question_id: 0 }, valid_session
          expect(response.status).to eq 301
        end
      end

      context "when no question_id param is given in the request" do
        it "raises error" do
          expect {
            get :index, {}, valid_session
          }.to raise_error(ActionController::ParameterMissing)
        end
      end

      context "question_id param given" do
        it "renders 'index' template" do
          get :index, { question_id: 0 }, valid_session
          response.should render_template('index')
        end

        it "assigns @question using question_id" do
          get :index, { question_id: 0 }, valid_session
          assigns(:question).should eq @question
        end
      end
    end

    describe "DELETE destroy"do
      context "when user has admin privileges" do
        it "destroys the requested answer" do
          answer = double(Answer)
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
          Answer.stub(:find).with("0").and_return(answer)
          answer.should_receive(:destroy)
          delete :destroy, {id: 0, question_id: 0}, valid_session
        end

        it "re-renders 'index' template" do
          answer = double(Answer)
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
          Answer.stub(:find).with("0").and_return(answer)
          answer.stub(:destroy)
          delete :destroy, {id: 0, question_id: 0}, valid_session
          response.should render_template('index')
        end
      end
      context "when user does not have admin privileges" do
        it "returns an error" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
          delete :destroy, {id: 0, question_id: 0}, valid_session
          expect(response.status).to eq 401
        end
      end
    end

    describe "GET reorder" do
      context "when user has admin privileges" do
        it "assigns @answers and @updates ordered by position using question_id" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
          get :reorder, { question_id: 0 }, valid_session
          assigns(:answers).should eq [@answers[0]]
          assigns(:updates).should eq [@answers[1]]
        end
      end
      context "when user has no admin privileges" do
        it "returns an error" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
          get :reorder, { question_id: 0 }, valid_session
          expect(response.status).to eq 401
        end
      end
    end
  end

  describe "GET new" do
    context "when user has admin privileges" do
      it "assigns a new answer as @answer" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        get :new, { question_id: 0 }, valid_session
        assigns(:answer).should be_a_new(Answer)
      end

      it "sets @answer.question_id to given question id" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        get :new, { question_id: 0 }, valid_session
        assigns(:answer).question_id.should eq 0
      end
    end
    context "when user has no admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        get :new, { question_id: 0 }, valid_session
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET edit" do
    context "when user has admin privileges" do
    it "renders 'edit' template" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
      answer = double(Answer)
      Answer.stub(:find).with("1").and_return(answer)
      get :edit, { id: 1 }, valid_session
      response.should render_template('edit')
    end

    it "assigns answer from id param as @answer" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
      answer = double(Answer)
      Answer.stub(:find).with("1").and_return(answer)
      get :edit, { id: 1 }, valid_session
      assigns(:answer).should eq answer
    end
    end
    context "when user has no admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        get :edit, { id: 1 }, valid_session
        expect(response.status).to eq 401
      end
    end

  end

  describe "PUT update" do
    context "with valid params" do
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

    context "with invalid params" do
      it "re-renders 'edit template'" do
        answer = double(Answer)
        Answer.stub(:find).with("0").and_return(answer)
        answer.stub(:update_attributes).and_return(false)
        put :update, :id => 0, :answer => { :label => "", :url => "", :question_id => 0, :type => "" }, :session => valid_session
        response.should render_template('edit')
      end
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
    context "with valid answer params" do
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

    context "with invalid answer params" do
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

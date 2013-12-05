=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Admin::QuestionsController do

  let(:valid_attributes) {
    { :display_text => "display text",
      :name => "name",
      :email => "email@email.com",
      :email_confirmation => "email@email.com",
      :picture_owner => "owner",
      :picture_attribution_url => "attribution_url",
      :picture_url => "url"
  }
  }
  let(:categories) { [FactoryGirl.create(:category),
                      FactoryGirl.create(:category)]}

  let(:voting_rounds) { [FactoryGirl.create(:voting_round, status: VotingRound::Status::New),
                         FactoryGirl.create(:voting_round, :other,  status: VotingRound::Status::Live)]}

  before do
    request.env['HTTPS'] = 'on'
  end

  describe "GET index" do
    context "not signed in" do
      it "redirects to sign in page" do
        question = double(:question)
        get :index, {}
        assigns(:questions).should_not eq([question])
      end
    end
  end

  context "signed in admin" do
    before do
      subject.stub(:signed_in_admin)
    end

    describe "GET filter_by_tag" do
      it "returns questions based on tags" do
        question1 = double(:question)
        Question.stub_chain(:tagged_with, :order).and_return([question1])
        get :filter_by_tag, {:tag => "some tag"}
        assigns(:questions).should eq [question1]
      end

      it "assigns all tags to @tags" do
        Question.should_receive(:tag_counts_on).with(:tags).and_return("a,b,c")
        Question.stub_chain(:tagged_with, :order)
        get :filter_by_tag, {:tag => "some tag"}
        assigns(:tags).should eq("a,b,c")
      end
    end

    context "not on SSL" do
      it "returns an error" do
        request.env['HTTPS'] = 'off'
        subject.stub(:ssl_configured).and_return(true)
        get :index
        expect(response.status).to eq 301
      end
    end

    describe "GET index" do
      it "assigns all questions as @questions" do
        questions = [double(:question), double(:question)]
        Question.should_receive(:order).with("created_at DESC").and_return(questions)
        get :index, {}
        assigns(:questions).should eq(questions)
      end

      it "assigns all tags to @tags" do
        Question.should_receive(:tag_counts_on).with(:tags).and_return("a,b,c")
        Question.stub(:order)
        get :index, {}
        assigns(:tags).should eq("a,b,c")
      end
    end

    describe "GET show" do
      it "assigns the requested question as @question" do
        question = FactoryGirl.create(:question)
        get :show, {:id => question.to_param}
        assigns(:question).should eq(question)
      end
    end

    describe "GET new" do
      context "user has admin privileges" do
        it "assigns a new question as @question" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
          get :new, {}
          assigns(:question).should be_a_new(Question)
        end

        it "assigns categories" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
          get :new, {}
          assigns(:categories).should == categories
        end
      end
      context "user has no admin privileges" do
        it "returns an error" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
          get :new, {}
          expect(response.status).to eq 401
        end
      end
    end

    describe "GET edit" do
      it "assigns the requested question as @question" do
        question = FactoryGirl.create(:question)
        get :edit, {:id => question.to_param}
        assigns(:question).should eq(question)
      end

      it "assigns categories" do
        question = FactoryGirl.create(:question)
        get :edit, {:id => question.to_param}
        assigns(:categories).should == categories
      end

      it "assigns new voting rounds" do
        question = FactoryGirl.create(:question)
        get :edit, {:id => question.to_param}
        assigns(:voting_rounds).should == [voting_rounds.first]
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Question" do
          expect {
            post :create, {:question => valid_attributes}
          }.to change(Question, :count).by(1)
        end

        it "assigns a newly created question as @question" do
          post :create, {:question => valid_attributes}
          assigns(:question).should be_a(Question)
          assigns(:question).should be_persisted
        end

        it "redirects to the created question" do
          post :create, {:question => valid_attributes}
          response.should redirect_to(admin_question_url(Question.last))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved question as @question" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {:question => { "original_text" => "invalid value" }}
          assigns(:question).should be_a_new(Question)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {:question => { "original_text" => "invalid value" }}
          response.should render_template("new")
        end
      end
    end

    describe "POST add_question_to_voting_round" do
      before do
        @voting_round = VotingRound.new()
        @voting_round.stub(:id).and_return(an_instance_of(String))
        @voting_round.stub(:add_question)
        @voting_round.stub(:save!)

        @question = Question.new(valid_attributes)
        @question.stub(:id).and_return(an_instance_of(String))

        VotingRound.stub(:find).with(@voting_round.id).and_return(@voting_round)
        Question.stub(:find).with(@question.id).and_return(@question)
      end

      context "when user does not have admin privileges" do
        it "returns an error" do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
          put :add_question_to_voting_round, id: @question.id, voting_round_id: @voting_round.id
          expect(response.status).to eq 401
        end
      end

      context "when user has admin privileges" do
        before do
          subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        end

        context "no voting round selected" do
          it "flashes error" do
            put :add_question_to_voting_round, id: @question.id, voting_round_id:""
            flash.now[:error].should eq "Please select a voting round to add"
          end
        end

        context "question already added to the voting round" do
          it "flashes error" do
            duplication_error = RuntimeError.new("some error")
            @voting_round.stub(:add_question).and_raise(duplication_error)
            put :add_question_to_voting_round, id: @question.id, voting_round_id:@voting_round.id
            flash.now[:error].should eq "some error"

          end
        end

        context "no voting round exists" do
          it "raises error" do
            VotingRound.stub(:find).with(@voting_round.id).and_return(nil)

            put :add_question_to_voting_round, id: @question.id, voting_round_id:@voting_round.id
            flash.now[:error].should eq "No voting round exists!"
          end
        end

        context "active question" do
          before do
            put :add_question_to_voting_round, id: @question.id, voting_round_id: @voting_round.id
          end

          it "render 'index' template" do
            response.should render_template("index")
          end

          it "create a voting_round_question" do
            @voting_round.should_receive(:add_question).with(@question)
            @voting_round.should_receive(:save!)
            put :add_question_to_voting_round, id: @question.id, voting_round_id: @voting_round.id
          end

          it "flash success notice" do
            flash.now[:notice].should eq "Question was successfully added to the voting round"
          end

          it "assigns all questions as @questions" do
            assigns(:questions).should eq([])
          end

          it "assigns all tags as @tags" do
            assigns(:tags).should eq([])
          end
        end

        context "removed question" do
          before do
            @question.status = Question::Status::Removed
            put :add_question_to_voting_round, id: @question.id, voting_round_id: @voting_round.id
          end

          it "render 'index' template" do
            response.should render_template("index")
          end

          it "not create a voting_round_question" do
            @voting_round.should_not_receive(:add_question).with(@question)
            @voting_round.should_not_receive(:save!)
            put :add_question_to_voting_round, id: @question.id, voting_round_id: @voting_round.id

          end

          it "flash error notice" do
            flash.now[:error].should eq "A removed question can not be added to voting round"
          end

          it "assigns all questions as @questions" do
            assigns(:questions).should eq([])
          end
        end
      end
    end

    describe "PUT update" do
      context "with valid params" do
        it "updates the requested question" do
          question = Question.create! valid_attributes
          # Assuming there are no other questions in the database, this
          # specifies that the Question created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Question.any_instance.should_receive(:update).with({ "original_text" => "MyText" })
          put :update, {:id => question.to_param, :question => { "original_text" => "MyText" }}
        end

        it "assigns the requested question as @question" do
          question = Question.create! valid_attributes
          put :update, {:id => question.to_param, :question => valid_attributes}
          assigns(:question).should eq(question)
        end

        it "redirects to the question" do
          question = Question.create! valid_attributes
          put :update, {:id => question.to_param, :question => valid_attributes}
          response.should redirect_to(admin_question_url(question))
        end
      end

      context "with invalid params" do
        before do
          Category.stub(:all).and_return([])
          VotingRound.stub(:where).and_return([])
        end

        it "assigns the question as @question" do
          question = Question.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          put :update, {:id => question.to_param, :question => { "original_text" => "invalid value" }}
          assigns(:question).should eq(question)
        end

        it "re-renders the 'edit' template" do
          question = Question.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          put :update, {:id => question.to_param, :question => { "original_text" => "invalid value" }}
          response.should render_template("edit")
        end
      end

      context "question is in a new voting round" do
        it "can not remove the question" do
          question = FactoryGirl.create(:question)
          voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::New)
          voting_round.add_question(question)
          voting_round.save!
          post :update, {:id => question.id, :question => { :status => Question::Status::Removed}}
          question.reload.active?.should be_true

          flash.now[:error].should eq "Can not update the question when it's in active (new or live) voting rounds"
        end
      end
    end

  end

  private
  def sign_in(admin)
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    admin.update_attribute(:remember_token, User.encrypt(remember_token))
  end
end

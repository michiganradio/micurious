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

  context "not signed in" do
    describe "GET index" do
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

    describe "GET index" do
      it "assigns all questions as @questions" do
        questions = [double(:question), double(:question)]
        Question.should_receive(:order).with("created_at DESC").and_return(questions)
        get :index, {}
        assigns(:questions).should eq(questions)
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
      it "assigns a new question as @question" do
        get :new, {}
        assigns(:question).should be_a_new(Question)
      end

      it "assigns categories" do
        get :new, {}
        assigns(:categories).should == categories
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

          flash.now[:error].should eq "Can not remove the question when it's in acitve(new, live) voting rounds"
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

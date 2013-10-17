require 'spec_helper'

describe Admin::QuestionsController do

  let(:valid_attributes) {
                           { :display_text => "display text",
                             :name => "name",
                             :email => "email@email.com",
                             :email_confirmation => "email@email.com"
                            }
                          }
  let(:categories) { [FactoryGirl.create(:category),
                      FactoryGirl.create(:category)]}

  context "not signed in" do
    describe "GET index" do
      it "redirects to sign in page" do
        question = FactoryGirl.create(:question)
        get :index, {}
        assigns(:questions).should_not eq([question])
      end
    end
  end

  context "signed in admin" do
    before { sign_in FactoryGirl.create(:user) }

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
      it "creates a voting_round_question" do
        voting_round = FactoryGirl.create(:voting_round)
        question = Question.create! valid_attributes
        put :add_question_to_voting_round, id: question.id
        response.should render_template("index")
      end
    end

    describe "PUT update" do
      describe "with valid params" do
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

      describe "with invalid params" do
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
    end

    describe "DELETE deactive" do
      it "marks the requested question inactive" do
        question = Question.create! valid_attributes
        expect {
          delete :deactivate, {:id => question.to_param}
        }.to change{Question.where(active: true).count}.by(-1)
      end

      it "does not destroy the requested question" do
        question = Question.create! valid_attributes
        expect {
          delete :deactivate, {:id => question.to_param}
        }.to_not change{Question.count}.by(-1)
      end

      it "redirects to the questions list" do
        question = Question.create! valid_attributes
        delete :deactivate, {:id => question.to_param}
        response.should redirect_to(admin_questions_url)
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

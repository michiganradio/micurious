require 'spec_helper'

describe QuestionsController do
  let(:valid_attributes) {
                           { :display_text => "display text",
                             :name => "name",
                             :email => "email@email.com",
                             :email_confirmation => "email@email.com"
                            }
                          }

  describe "GET show" do
    it "assigns the requested question as @question" do
      question = Question.create! valid_attributes
      get :show, {:id => question.to_param}
      assigns(:question).should eq(question)
      assigns(:ask).should eq true
    end
  end

  describe "POST new" do
    it "assigns a new question as @question" do
      post :new, {:format => 'js'}
      assigns(:question).should be_a_new(Question)
    end

    it "assigns categories" do
      category = FactoryGirl.create(:category)
      post :new, {:format => 'js'}
      assigns(:categories).should == [category]
    end

    it "assigns passed params into the question" do
      post :new, {:display_text => 'display', :name => 'name', :anonymous => 'true', :email => 'lkj@lkj.com', :format=> 'js'}
      question = assigns(:question)
      expect(question.display_text).to eq 'display'
      expect(question.name).to eq 'name'
      expect(question.anonymous).to eq true
      expect(question.email).to eq 'lkj@lkj.com'
    end
  end

  describe "POST create" do
    it "creates a new Question" do
      Question.any_instance.should_receive(:save).and_return(true)
      post :create, :question => valid_attributes, format: 'js'
    end

    describe "with valid params" do
      it "renders the received template" do
        Question.any_instance.stub(:save).and_return(true)
        post :create, :question => valid_attributes, format: 'js'
        response.should render_template("received.js.erb")
      end
    end

    describe "with invalid params" do
      it "renders the new template" do
        Question.any_instance.stub(:save).and_return(false)
        post :create, :question => valid_attributes, format: 'js'
        response.should render_template("new.js.erb")
      end
    end

  end

  describe "POST confirm" do
    describe "with valid params" do
      it "assigns the new question as @question" do
        Question.any_instance.stub(:valid?).and_return(true)
        post :confirm, question: valid_attributes, format: 'js'
        assigns(:question).should be_a_new(Question)
      end
      it "renders the 'confirm' template" do
        Question.any_instance.stub(:valid?).and_return(true)
        post :confirm, question: { "original_text" => "invalid value" }, format: 'js'
        response.should render_template("confirm.js.erb")
      end
    end
    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        Question.any_instance.stub(:valid?).and_return(false)
        post :confirm, question: { "original_text" => "invalid value" }, format: 'js'
        assigns(:question).should be_a_new(Question)
      end
      it "renders the 'new' template" do
        Question.any_instance.stub(:valid?).and_return(false)
        post :confirm, question: { "original_text" => "invalid value" }, format: 'js'
        response.should render_template("new.js.erb")
      end
    end
  end
end

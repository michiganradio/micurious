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
    end
  end

  describe "GET filter" do
    before do
      subject.stub(:load_categories)
    end

    context "no category id given" do
      it "loads all question as @questions" do
        questions = [double(:question)]
        Question.stub(:order).with(created_at: :desc).and_return(questions)
        get :filter, {}
        assigns(:questions).should eq(questions)
      end
    end

    context "category id given" do
      it "loads all questions with category as @questions" do
        question = double(:question)
        Question.should_receive(:with_category).with("category name").and_return([question])
        get :filter, category_name: "category name"
        assigns(:questions).should eq([question])
      end
    end
  end

  describe "POST new" do
    it "assigns a new question as @question" do
      post :new, {:format => 'js'}
      assigns(:question).should be_a_new(Question)
    end

    it "assigns passed params into the question" do
      post :new, {:display_text => 'display', :name => 'name', :anonymous => 'true',
                  :email => 'lkj@lkj.com', :email_confirmation => 'confirm@lkj.com', :format=> 'js'}
      question = assigns(:question)
      expect(question.display_text).to eq 'display'
      expect(question.name).to eq 'name'
      expect(question.anonymous).to eq true
      expect(question.email).to eq 'lkj@lkj.com'
      expect(question.email_confirmation).to eq 'confirm@lkj.com'
    end
  end

  describe "POST picture" do
    it "keeps the question" do
      post :picture, :question => valid_attributes, format: 'js'
      response.should render_template("picture.js.erb")
    end
  end

  describe "POST find_pictures" do
    it "returns pictures" do
      mock_flickr_service = double(FlickrService)
      mock_flickr_service.stub(:find_pictures).and_return("some photos")
      FlickrService.stub(:new).and_return(mock_flickr_service)
      post :find_pictures, :question => valid_attributes, :searchfield => "chicago", format: 'js'
      assigns(:pictures).should == "some photos"
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

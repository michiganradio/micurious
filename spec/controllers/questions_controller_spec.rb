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
    before do
      @question = double(Question)
      @answers = [double(Answer), double(Answer)]
      Question.stub(:find).with("0").and_return(@question)
      @question.stub(:answers).and_return(@answers)
      @answers.stub(:order).and_return(@answers)
      @answers.stub(:where).with(type: Answer::Type::Answer).and_return([@answers[0]])
      @answers.stub(:where).with(type: Answer::Type::Update).and_return([@answers[1]])
    end

    it "sets @question to question found by id param" do
      @question.stub(:status).and_return(Question::Status::New)
      get :show, {:id => 0}
      assigns(:question).should eq(@question)
    end

    it "redirects to root if question is removed" do
      @question.stub(:status).and_return(Question::Status::Removed)
      get :show, {:id => 0}
      response.should redirect_to(root_url)
    end
  end

  describe "GET filter" do
    before do
      subject.stub(:load_categories)
    end

    context "archive status " do
      it "filters questions with new status" do
        questions = [double(:question, featured?:false)]
        statuses = [Question::Status::New]
        Question.should_receive(:with_status_and_category).with(statuses, 'somecategory').and_return(questions)
        get :filter, {:status => 'archive', :category_name => 'somecategory'}
        assigns(:questions).should eq questions
      end
    end

    context "answered" do
      it "filters questions with answered and investigating"  do
        question1 = double(:question, featured?: true)
        question2 = double(:question, featured?:false)
        statuses = [Question::Status::Answered, Question::Status::Investigating]
        Question.should_receive(:with_status_and_category).with(statuses,'somecategory').and_return([question1, question2])
        get :filter, {:status => 'answered', :category_name => 'somecategory'}
        assigns(:questions).should eq [question1, question2]
        assigns(:featured_answers).should eq [question1]
      end
    end
  end

  describe "POST new" do
    it "assigns a new question as @question" do
      post :new, {:format => 'js'}
      assigns(:question).should be_a_new(Question)
    end

    it "assigns passed params into the question" do
      post :new, { :display_text => 'display', :description => 'description', :name => 'name',
                   :anonymous => 'true', :email => 'lkj@lkj.com', :email_confirmation => 'confirm@lkj.com',
                   :neighbourhood => 'neighbourhood', :picture_url => 'picture url',
                   :picture_owner => 'picture owner', :picture_attribution_url => 'picture attribution url',
                   :format => 'js' }
      question = assigns(:question)
      expect(question.display_text).to eq 'display'
      expect(question.description).to eq 'description'
      expect(question.name).to eq 'name'
      expect(question.anonymous).to eq true
      expect(question.email).to eq 'lkj@lkj.com'
      expect(question.email_confirmation).to eq 'confirm@lkj.com'
      expect(question.neighbourhood).to eq 'neighbourhood'
      expect(question.picture_url).to eq 'picture url'
      expect(question.picture_owner).to eq 'picture owner'
      expect(question.picture_attribution_url).to eq 'picture attribution url'
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

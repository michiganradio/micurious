=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe QuestionsController do
  let(:valid_attributes) {
                           { :display_text => "display text",
                             :name => "name",
                             :email => "email@email.com",
                             :email_confirmation => "email@email.com"
                            }
                          }
  let(:valid_mobile_attributes) {
                           { :display_text => "display text",
                             :name => "name",
                             :email => "email@email.com",
                             :neigbourhood => "something"
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

  describe "GET search" do
    it "renders user question search page" do
      get :search, {}
      response.should render_template("search")
    end
  end

  describe "GET filter" do
    before do
      subject.stub(:load_categories)
    end

    context "when the user wants new questions" do
      it "filters questions for those with the new status" do
        questions = [double(:question, featured?:false)]
        statuses = [Question::Status::New]
        Question.should_receive(:with_status_and_category).with(statuses, 'somecategory').and_return(questions)
        questions.should_receive(:paginate).with(page: "1").and_return(questions)
        Question.stub_chain(:with_status_and_category, :where).and_return([])
        get :filter, {:status => 'archive', :category_name => 'somecategory', :page => 1}
        assigns(:questions).should eq questions
      end
    end

    context "when the user wants answered questions" do
      it "filters questions for those with answered or investigating statuses"  do
        question1 = double(:question, featured?: true)
        question2 = double(:question, featured?:false)
        statuses = [Question::Status::Answered, Question::Status::Investigating]
        questions = [question1, question2]
        featured = [question1]
        Question.should_receive(:with_status_and_category).with(statuses,'somecategory').and_return(questions)
        Question.stub_chain(:with_status_and_category, :where).and_return(featured)
        questions.should_receive(:paginate).with(page: "1").and_return(questions)
        get :filter, {:status => 'answered', :category_name => 'somecategory', :page => 1}
        assigns(:questions).should eq questions
        assigns(:featured_answers).should eq featured
      end
    end
  end

  describe "GET ask_mobile" do
    it "assigns a new question as @question" do
      get :ask_mobile, {}
      assigns(:question).should be_a_new(Question)
    end
  end

  describe "POST submit_mobile" do
    it "creates a new Question" do
      Question.any_instance.should_receive(:save).and_return(true)
      post :submit_mobile, :question => valid_mobile_attributes
      response.should redirect_to :confirm_mobile
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
    it "renders the image" do
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


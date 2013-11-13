require 'spec_helper'
require 'roo'

describe "question migration" do
  before do
    @test_file = "./spec/lib/migrate/test.xls"
    @question_migrate = MigrateQuestion.new
    @column_indices = { "Badge"=>0, "Approved"=>1, "Anonymous"=>2, "Categories"=>3,
                        "Date Uploaded"=>4, "Image Url"=>5 }
  end
  it "gets column indices of wanted attributes" do
    sheet = Roo::Excel.new(@test_file)
    hashed_column_indices = @question_migrate.get_spreadsheet_column_indices(["Voting Period", "Name"], sheet)
    hashed_column_indices["Voting Period"].should eq 1
    hashed_column_indices["Name"].should eq 2
  end

  describe "generates the Question-specific status from the spreadsheet" do
    it "sets the status of the question to be answered" do
      row = ["answered", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices )
      question.status.should eq Question::Status::Answered
    end

    it "sets the status of the question to be investigated" do
      row = ["investigated", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.status.should eq Question::Status::Investigating
    end

    it "sets the status of the question to be new" do
      row = ["", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.status.should eq Question::Status::New
    end

    it "sets the status of the question to be removed" do
      row = ["", 0, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.status.should eq Question::Status::Removed
    end

    it "sets the email confirmation to be the email" do
      row = ["", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      question.email = "a@a.com"
      @question_migrate.map_question_data(row, question, @column_indices)
      question.email_confirmation.should eq "a@a.com"
    end

    it "sets anonymous to be true" do
      row = ["", 1, 1.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.anonymous.should eq true
    end

    it "sets anonymous to be false" do
      row = ["", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.anonymous.should eq false
    end
  end

  describe "sets categories for question" do
    it "sets the categories for question listed in spreadsheet" do
      category1 = stub_model(Category, id: 1, name: "category1")
      category2 = stub_model(Category, id: 2, name: "category2")
      Category.should_receive(:where).with({ name: category1.name }).and_return([category1])
      Category.should_receive(:where).with({ name: category2.name }).and_return([category2])
      row = ["category1, category2"]
      column_indices = { "Categories" => 0 }
      question = Question.new
      @question_migrate.map_question_categories(row, question, column_indices)
      question.categories.should eq [category1, category2]
    end
  end

  describe "sets created_at for question" do
    it "sets created_at from date uploaded column" do
      row = ["", 1, 0.0, "", "1344395668", "images/default.jpg"]
      question = Question.new
      @question_migrate.map_question_data(row, question, @column_indices)
      question.created_at.should eq Time.at(1344395668)
    end
  end

  describe "sets picture_url for question" do
    context "Image Url cell in row is 'images/default.jpg'" do
      it "picture_url is nil" do
        row = ["", 1, 0.0, "", "1344395668", "images/default.jpg"]
        question = Question.new
        @question_migrate.map_question_data(row, question, @column_indices)
        question.picture_url.should eq nil
      end
    end

    context "Image Url cell in row is not 'images/default.jpg'" do
      it "picture_url is set to Image Url cell" do
        row = ["", 1, 0.0, "", "1344395668", "image url"]
        question = Question.new
        @question_migrate.map_question_data(row, question, @column_indices)
        question.picture_url.should eq "image url"
      end
    end
  end

  it "migrates question" do
    category1 = stub_model(Category, id: 1, name: "how-we-live")
    category2 = stub_model(Category, id: 2, name: "governance")
    category3 = stub_model(Category, id: 3, name: "whats-it-like")
    category4 = stub_model(Category, id: 4, name: "economy")
    Category.should_receive(:where).with({ name: category1.name }).and_return([category1])
    Category.should_receive(:where).with({ name: category2.name }).and_return([category2])
    Category.should_receive(:where).with({ name: category3.name }).and_return([category3])
    Category.should_receive(:where).with({ name: category4.name }).and_return([category4])
    save_count = 0
    Question.any_instance.stub(:save) { save_count+=1 }
    saved_questions = @question_migrate.migrate_question(@test_file)
    saved_questions[0].id.should eq 1
    saved_questions[0].display_text.should eq "This is a question?"
    saved_questions[0].anonymous.should eq false
    saved_questions[1].id.should eq 2
    saved_questions[1].display_text.should eq "This is a curious question?"
    saved_questions[1].anonymous.should eq true
    save_count.should == 2
  end
end

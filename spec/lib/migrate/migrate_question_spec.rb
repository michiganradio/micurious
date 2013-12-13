=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'
require 'roo'

describe "question migration" do
  before do
    @test_file = "./spec/lib/migrate/test.xls"
    @question_migrate = MigrateQuestion.new
    @row = ["", 1, 0.0, "", "1344395668", "images/default.jpg", "", "", ""]
    @column_indices = { "Badge"=>0, "Approved"=>1, "Anonymous"=>2,
                        "Categories"=>3, "Date Uploaded"=>4,
                        "Image Url"=>5, "Response Link URL"=>6,
                        "Response Link Text"=>7, "Timeline Key"=>8 }
  end

  it "gets column indices of wanted attributes" do
    sheet = Roo::Excel.new(@test_file)
    hashed_column_indices = @question_migrate.get_spreadsheet_column_indices(["Voting Period", "Name"], sheet)
    hashed_column_indices["Voting Period"].should eq 1
    hashed_column_indices["Name"].should eq 2
  end

  it "maps generic data" do
    question = Question.new
    row = [1, "Questioner Name", "questioner@email.com",
           "This is an original question?", "This is a question?",
           "imageURL", "imageAttributionURL","imageOwner",
           "ChicagoNeighbourhood", "ReporterName"]
    spreadsheet_to_question_attributes = {
      "id"=>"id", "Question"=>"display_text",
      "Original Question"=>"original_text",
      "Neighbourhood"=>"neighbourhood", "Name"=>"name",
      "Email"=>"email", "Image Attribution"=>"picture_attribution_url",
      "Username"=>"picture_owner", "Image Url"=>"picture_url",
      "Reporter"=>"reporter"
    }
    column_indices = {
      "id"=>0, "Name"=>1, "Email"=>2, "Original Question"=>3, "Question"=>4,
      "Image Url"=>5, "Image Attribution"=>6, "Username"=>7, "Neighbourhood"=>8,
      "Reporter"=>9
    }

    @question_migrate.map_generic_data(row, question, spreadsheet_to_question_attributes, column_indices)

    question.id.should eq row[0]
    question.name.should eq row[1]
    question.email.should eq row[2]
    question.original_text.should eq row[3]
    question.display_text.should eq row[4]
    question.picture_url.should eq row[5]
    question.picture_attribution_url.should eq row[6]
    question.picture_owner.should eq row[7]
    question.neighbourhood.should eq row[8]
    question.reporter.should eq row[9]
  end

  describe "generates the Question-specific status from the spreadsheet" do
    it "sets the status of the question to be answered" do
      @row[0] = "answered"
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices )
      question.status.should eq Question::Status::Answered
    end

    it "sets the status of the question to be investigated" do
      @row[0] = "investigated"
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.status.should eq Question::Status::Investigating
    end

    it "sets the status of the question to be new" do
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.status.should eq Question::Status::New
    end

    it "sets the status of the question to be removed" do
      @row[1] = 0
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.status.should eq Question::Status::Removed
    end

    it "sets the email confirmation to be the email" do
      question = Question.new
      question.email = "a@a.com"
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.email_confirmation.should eq "a@a.com"
    end

    it "sets anonymous to be true" do
      @row[2] = 1.0
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.anonymous.should eq true
    end

    it "sets anonymous to be false" do
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.anonymous.should eq false
    end
  end

  describe "sets categories for question" do
    it "sets the categories for question listed in spreadsheet" do
      category1 = stub_model(Category, id: 1, name: "category1")
      category2 = stub_model(Category, id: 2, name: "category2")
      Category.should_receive(:where).with({ name: category1.name }).and_return([category1])
      Category.should_receive(:where).with({ name: category2.name }).and_return([category2])
      category_names = "category1, category2"

      categories = @question_migrate.map_question_categories(category_names)

      categories.should eq [category1, category2]
    end
  end

  describe "sets created_at for question" do
    it "sets created_at from date uploaded column" do
      question = Question.new
      @question_migrate.map_question_data(@row, question, @column_indices)
      question.created_at.should eq Time.at(1344395668)
    end
  end

  describe "sets picture url for question" do
    context "when image url cell in row is 'images/default.jpg'" do
      it "pictureurl is nil" do
        question = Question.new
        @question_migrate.map_question_data(@row, question, @column_indices)
        question.picture_url.should eq nil
      end
    end

    context "when image url cell in row is not 'images/default.jpg'" do
      it "picture_url is set to image url cell" do
        @row[5] = "image url"
        question = Question.new
        @question_migrate.map_question_data(@row, question, @column_indices)
        question.picture_url.should eq "image url"
      end
    end
  end

  describe "generates answer for question" do
    context "response link text and url cells are not empty" do
      it "add new answer using response link" do
        response_link_url = "url"
        response_link_text = "text"
        question_id = 2

        answer = @question_migrate.map_question_answer(response_link_text, response_link_url, question_id)

        answer.type.should eq Answer::Type::Answer
        answer.label.should eq response_link_text
        answer.url.should eq response_link_url
        answer.question_id.should eq question_id
      end
    end

    context "response link text cell is empty" do
      it "do not add new answer" do
        response_link_url = "url"
        response_link_text = ""
        question_id = 2

        answer = @question_migrate.map_question_answer(response_link_text, response_link_url, question_id)

        answer.should eq nil
      end
    end
  end

  describe "generates timeline update for question"do
    context "when timeline key is not empty" do
      it "add new update using timeline key" do
        timeline_key = "123"
        question_id = 2

        update = @question_migrate.map_question_timeline_update(timeline_key, question_id)

        update.type.should eq Answer::Type::Update
        update.label.should eq "Our reporting on this question"
        update.url.should eq "http://cdn.knightlab.com/libs/timeline/latest/embed/index.html?source=#{timeline_key}&font=Bevan-PotanoSans"
        update.question_id.should eq question_id
      end
    end

    context "when timeline key is empty" do
      it "do not add new update" do
        timeline_key = ""
        question_id = 2

        update = @question_migrate.map_question_timeline_update(timeline_key, question_id)

        update.should eq nil
      end
    end
  end

  it "calls save on questions" do
    category = stub_model(Category, id: 1, name: "category")
    Category.stub(:where).and_return([category])
    save_count = 0
    Question.any_instance.stub(:save) { save_count += 1 }
    questions = @question_migrate.migrate_question(@test_file)
    save_count.should == 2
  end
end

require 'spec_helper'
require 'roo'

describe "migration" do
  before do
  @test_file = "./spec/lib/migrate/test.xls"
  end
  it "gets column indices of wanted attributes" do
    sheet = Roo::Excel.new(@test_file)
    hashed_column_indices = get_spreadsheet_column_indices(["Voting Period", "Name"], sheet)
    hashed_column_indices["Voting Period"].should eq 1
    hashed_column_indices["Name"].should eq 2
  end

  context "generates the Question-specific status from the spreadsheet" do
    it "sets the status of the question to be answered" do
      row = ["answered", 1]
      question = Question.new
      column_indices = {"Badge"=>0, "Approved"=>1}
      map_question_data(row, question,column_indices )
      question.status.should eq "answered"
    end
    it "sets the status of the question to be investigated" do
      row = ["investigated", 1]
    column_indices = {"Badge"=>0, "Approved"=>1}
      question = Question.new
      map_question_data(row, question, column_indices)
      question.status.should eq "investigated"
    end
    it "sets the status of the question to be new" do
      row = ["", 1]
      column_indices = {"Badge"=>0, "Approved"=>1}
      question = Question.new
      map_question_data(row, question, column_indices)
      question.status.should eq "new"
    end
    it "sets the status of the question to be removed" do
      row = ["",0]
      column_indices = {"Badge"=>0, "Approved"=>1}
      question = Question.new
      map_question_data(row, question, column_indices)
      question.status.should eq "removed"
    end
    it "sets the email confirmation to be the email" do
      row = ["",1]
      column_indices = {"Badge"=>0, "Approved"=>1}
      question = Question.new
      question.email = "a@a.com"
      map_question_data(row, question, column_indices)
      question.email_confirmation.should eq "a@a.com"
    end
  end


  it "migrates question" do
    Question.any_instance.should_receive(:save).and_return(true)
    saved_questions = migrate_question(@test_file)
    saved_questions[0].id.should eq 1
    saved_questions[0].display_text.should eq "This is a question?"
    saved_questions[0].anonymous.should eq false
  end
end

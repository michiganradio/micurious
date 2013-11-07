require 'spec_helper'
require 'roo'

describe "migration" do
  before do
  @test_file = "./spec/lib/migrate/test.xls"
  end
  it "gets column indices of wanted attributes" do
    sheet = Roo::Excel.new(@test_file)
    hashed_column_indices = get_spreadsheet_column_indices(["Voting Period", "Name"], sheet)
    hashed_column_indices["Voting Period"].should eq 2
    hashed_column_indices["Name"].should eq 3
  end
  it "migrates question" do
    Question.any_instance.should_receive(:save).and_return(true)
    saved_questions = migrate_question(@test_file)
    saved_questions[0].id.should eq 1
    saved_questions[0].display_text.should eq "This is a question?"
    saved_questions[0].anonymous.should eq false
  end
end

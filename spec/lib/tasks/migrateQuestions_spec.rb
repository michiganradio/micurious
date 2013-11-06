require 'spec_helper'
require 'CSV'
describe MigrateQuestions do

  before do
    @migration = MigrateQuestions.new
  end

  it "get all the question data from the csv" do
    csv_table = double(CSV::Table)
    csv_table.stub(:by_col!)
    csv_table.stub(:delete_if).and_return("filtered table")
    question_data = @migration.take_question_data(csv_table)
    question_data.should eq "filtered table"
  end

  it "saves new csv file" do
    csv_table = double(CSV::Table)
    csv_table.stub(:to_csv).and_return("table")
    @migration.generate_question_csv(csv_table)
    File.should be_exist("lib/migrate/question.csv")
  end

  it "saves mysql script" do
    @migration.generate_question_sql
    File.should be_exist("lib/migrate/question.sql")
  end
end

require 'spec_helper'
require 'roo'

describe "answer migration" do
  before do
    @test_file = "./spec/lib/migrate/test.xls"
    @answer_migrate = MigrateAnswer.new
  end
  it "migrates question" do
    Answer.any_instance.should_receive(:save).and_return(true)
    saved_answers = @answer_migrate.migrate_answer(@test_file)
    saved_answers[0].url.should eq "url"
    saved_answers[0].label.should eq "label"
  end

  it "sets type to answer" do
    answer = Answer.new
    @answer_migrate.map_answer_data(answer)
    answer.type.should eq Answer::Type::Answer
  end
end

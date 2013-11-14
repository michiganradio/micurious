require 'spec_helper'
require 'roo'

describe MigrateVotingRound do
  before do
    @test_file = "./spec/lib/migrate/test.xls"
    @voting_round_migrate = MigrateVotingRound.new
  end

  describe "#map_voting_round_start_time" do
    context "start time and end time have same year" do
      it "returns start time" do
        label = "January 23 - February 6, 2013"
        start_time = @voting_round_migrate.map_voting_round_start_time(label)
        start_time.should eq DateTime.parse("January 23, 2013")
      end
    end

    context "start time and end time have different years" do
      it "returns start time" do
        label = "January 23, 2012 - February 6, 2013"
        start_time = @voting_round_migrate.map_voting_round_start_time(label)
        start_time.should eq DateTime.parse("January 23, 2012")
      end
    end
  end

  describe "#map_voting_round_end_time" do
    it "returns end time" do
      label = "January 23 - February 6, 2013"
      end_time = @voting_round_migrate.map_voting_round_end_time(label)
      end_time.should eq DateTime.parse("February 6, 2013")
    end
  end

  describe "#migrate_voting_round" do
    it "calls save on voting rounds" do
      VotingRound.any_instance.should_receive(:save)
      questions = @voting_round_migrate.migrate_voting_round(@test_file)
    end
  end

  describe "#get_voting_round_question" do
    spreadsheet_to_voting_round_question_attributes = { "Id"=>"question_id",
                                                        "Votes"=>"vote_number" }
  end
end

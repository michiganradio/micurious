=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'
require 'roo'

describe MigrateVotingRound do
  before do
    @test_file = "./spec/lib/migrate/test.xls"
    @voting_round_migrate = MigrateVotingRound.new
  end

  describe "#map_voting_round_start_time" do
    context "when start time and end time have same year" do
      it "returns start time" do
        public_label = "January 23 - February 6, 2013"
        start_time = @voting_round_migrate.map_voting_round_start_time(public_label)
        start_time.should eq DateTime.parse("January 23, 2013")
      end
    end

    context "when start time and end time have different years" do
      it "returns start time" do
        public_label = "January 23, 2012 - February 6, 2013"
        start_time = @voting_round_migrate.map_voting_round_start_time(public_label)
        start_time.should eq DateTime.parse("January 23, 2012")
      end
    end
  end

  describe "#map_voting_round_end_time" do
    it "returns end time" do
      public_label = "January 23 - February 6, 2013"
      end_time = @voting_round_migrate.map_voting_round_end_time(public_label)
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

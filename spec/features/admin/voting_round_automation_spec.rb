=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "Automate question status change in voting round" do
  context "when the voting round status changes to completed" do
    it "changes winning question status to investigated" do
      signin_as_admin
      @voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
      @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question), FactoryGirl.create(:question)]
      @voting_round.questions = @questions
      VotingRoundQuestion.where(question_id: @questions[0].id).first.update_attributes(vote_number: 10)
      VotingRoundQuestion.where(question_id: @questions[1].id).first.update_attributes(vote_number: 0)
      VotingRoundQuestion.where(question_id: @questions[2].id).first.update_attributes(vote_number: 5)

      @admin_edit_voting_round_page = Admin::EditVotingRound.new
      @admin_edit_voting_round_page.load(id: @voting_round.id)
      @admin_edit_voting_round_page.status_dropdown.select(VotingRound::Status::Completed)
      @admin_edit_voting_round_page.update_button.click
      @admin_show_question_page = Admin::ShowQuestion.new
      @admin_show_question_page.load(id: @questions[0].id)
      @admin_show_question_page.status.text.should eq Question::Status::Investigating
    end
  end
end

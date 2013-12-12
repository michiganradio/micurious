=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "/admin/voting_rounds/{index} remove question from voting round" do
  before do
    signin_as_admin
    @question = FactoryGirl.create(:question)
    @voting_round = FactoryGirl.create(:voting_round)
    @voting_round.add_question(@question)
    @admin_show_voting_round_page = Admin::ShowVotingRound.new
  end

  context "when the question is only in one voting round" do
    before do
      @admin_show_voting_round_page.load(id: @voting_round.id)
      @admin_show_voting_round_page.question_remove_links.first.click
    end

    it "does not have question on voting round page" do
      expect(@admin_show_voting_round_page.has_question? /#{@question.display_text}/).to be_false
    end

    it "displays confirmation message" do
      @admin_show_voting_round_page.remove_question_confirmation.text.should ==
        "Question was successfully removed from the voting round"
    end
  end

  context "when the question is in another voting round" do
    it "does not remove question from other voting round page" do
      voting_round_other = FactoryGirl.create(:voting_round, :other)
      voting_round_other.add_question(@question)

      @admin_show_voting_round_page.load(id: @voting_round.id)
      @admin_show_voting_round_page.question_remove_links.first.click

      @admin_show_voting_round_page.load(id: voting_round_other.id)
      expect(@admin_show_voting_round_page.has_question? /#{@question.display_text}/).to be_true
    end
  end
end

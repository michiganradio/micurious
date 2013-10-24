require 'features/features_spec_helper'

describe "Remove question from voting round" do
  before do
    @question = FactoryGirl.create(:question)
    @voting_round = FactoryGirl.create(:voting_round)
    @voting_round.add_question(@question)
    @admin_show_voting_round_page = Admin::ShowVotingRound.new
  end

  context "question is only in one voting round" do
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

  context "question is in another voting round" do
    it "does not remove question from other voting round page" do
      voting_round_other = FactoryGirl.create(:voting_round)
      voting_round_other.add_question(@question)

      @admin_show_voting_round_page.load(id: @voting_round.id)
      @admin_show_voting_round_page.question_remove_links.first.click

      @admin_show_voting_round_page.load(id: voting_round_other.id)
      expect(@admin_show_voting_round_page.has_question? /#{@question.display_text}/).to be_true
    end
  end
end

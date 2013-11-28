require 'features/features_spec_helper'

describe "admin adding question to voting round" do
  before do
    signin_as_admin
    @question = FactoryGirl.create(:question )
    @voting_round = FactoryGirl.create(:voting_round)
    @edit_admin_question_page = Admin::EditQuestion.new
  end

  context "with an active question" do
    before do
      @edit_admin_question_page.load(id: @question.id)
      @edit_admin_question_page.private_label_dropdown.select(@voting_round.private_label)
      @edit_admin_question_page.add_question_to_voting_round_button.click
    end

    it "displays confirmation message" do
      @edit_admin_question_page.add_question_to_voting_round_confirmation.text.should ==
        "Question was successfully added to the voting round"
    end

    it "displays the added question on voting round page" do
      @show_admin_voting_round_page = Admin::ShowVotingRound.new
      @show_admin_voting_round_page.load(id: @voting_round.id)
      expect(@show_admin_voting_round_page.has_question? /#{@question.display_text}/).to be_true
    end
  end

  context "with a deactivated question" do
    before do
      @removed_question = FactoryGirl.create(:question, status: Question::Status::Removed)
      @edit_admin_question_page_removed = Admin::EditQuestion.new
      @edit_admin_question_page_removed.load(id: @removed_question.id)
    end

    it "displays error message" do
      @edit_admin_question_page.private_label_dropdown.select(@voting_round.private_label)
      @edit_admin_question_page_removed.add_question_to_voting_round_button.click
      @edit_admin_question_page_removed.add_question_to_voting_round_error.text.should eq "A removed question can not be added to voting round"
    end
  end
end

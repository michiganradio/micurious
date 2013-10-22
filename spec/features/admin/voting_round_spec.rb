require 'features/features_spec_helper'

describe "Manage voting round" do
  let(:voting_round) { FactoryGirl.create(:voting_round) }

  it "edit voting round label" do
    @edit_admin_voting_round_page = Admin::EditVotingRound.new
    @edit_admin_voting_round_page.load(id: voting_round.id)
    @edit_admin_voting_round_page.label.set "new label text"
    @edit_admin_voting_round_page.update_button.click

    @show_admin_voting_round_page = Admin::ShowVotingRound.new
    @show_admin_voting_round_page.load(id: voting_round.id)
    @show_admin_voting_round_page.label.text.should ==
        "new label text"
  end
end

describe "QuestionEditPage" do
  describe "add question to voting round" do
    before do
      @question = FactoryGirl.create(:question)
      FactoryGirl.create(:voting_round)
      @edit_admin_question_page = Admin::EditQuestion.new
      @edit_admin_question_page.load(id: @question.id)
    end

    it "has add question to voting round button" do
      @edit_admin_question_page.has_add_question_to_voting_round_button?
    end

    describe "add button clicked" do
      context "active question" do
        it "displays confirmation message" do
          @edit_admin_question_page.add_question_to_voting_round_button.click
          @edit_admin_question_page.add_question_to_voting_round_confirmation.text.should ==
            "Question was successfully added to the voting round"
        end
      end

      context "deactivated question" do
        before do
          @deactivated_question = FactoryGirl.create(:question, active: false)
          @edit_admin_question_page_deactivated = Admin::EditQuestion.new
          @edit_admin_question_page_deactivated.load(id: @deactivated_question.id)
        end

        it "displays error message" do
          @edit_admin_question_page_deactivated.add_question_to_voting_round_button.click
          @edit_admin_question_page_deactivated.add_question_to_voting_round_error.text.should ==
            "Deactivated question can not be added to voting round"
        end
      end
    end
  end
end

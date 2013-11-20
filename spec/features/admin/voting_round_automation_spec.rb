require 'features/features_spec_helper'

describe "Automate question status change in voting round" do
  context "voting round status changes to completed" do
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

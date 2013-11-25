require 'features/features_spec_helper'

describe "browse past voting rounds" do
  before do
    @question = FactoryGirl.create(:question)
    @other_question = FactoryGirl.create(:question, :other, status: Question::Status::Investigating)
    @oldest_voting_round = FactoryGirl.create(:voting_round, :completed, start_time: "2000-01-01 11:11:11", public_label: "public", private_label: "private")
    @voting_round = FactoryGirl.create(:voting_round, :completed, questions: [@question, @other_question])
    VotingRoundQuestion.where(question_id: @question.id).first.update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @other_question.id).first.update_attributes(vote_number: 10)
    @newer_voting_round = FactoryGirl.create(:voting_round, :completed, start_time: "2013-11-01 11:11:11", public_label: "public2", private_label: "private2", questions: [@question, @other_question])
    VotingRoundQuestion.where(question_id: @question.id)[1].update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @other_question.id)[1].update_attributes(vote_number: 10)
    @live_voting_round = FactoryGirl.create(:voting_round, :other, :live)
  end

  it "is linked to from the home page" do
    home = Home.new
    home.load
    home.should have_link("Voting for " + @newer_voting_round.public_label, href: voting_round_path(@newer_voting_round.id))
  end

  it "has links to previous and next voting rounds" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @voting_round.id.to_s)
    vr.should have_link("Voting for " + @oldest_voting_round.public_label, href: voting_round_path(@oldest_voting_round.id))
    vr.should have_link("Voting for " + @newer_voting_round.public_label, href: voting_round_path(@newer_voting_round.id))
  end

  it "shows the home page when navigating to live voting round" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @newer_voting_round.id.to_s)
    vr.should have_link("Voting for " + @live_voting_round.public_label)
    home = Home.new
    home.should be_displayed
  end

  it "shows voting round" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @voting_round.id.to_s)
    vr.questions[0].should have_content @other_question.display_text
    vr.questions[1].should have_content @question.display_text
  end

  it "shows percentage" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @voting_round.id.to_s)
    vr.questions[0].should have_content "100%"
  end

  it "does not show answered badge" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @voting_round.id.to_s)
    vr.questions[0].should_not have_selector(".checkmark")
  end
end

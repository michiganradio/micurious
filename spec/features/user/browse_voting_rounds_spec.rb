require 'features/features_spec_helper'

describe "browse past voting rounds" do
  before do
    @question = FactoryGirl.create(:question)
    @other_question = FactoryGirl.create(:question, :other)
    @oldest_voting_round = FactoryGirl.create(:voting_round, :completed, start_time: "2000-01-01 11:11:11", label: "label")
    @voting_round = FactoryGirl.create(:voting_round, :completed, questions: [@question, @other_question])
    VotingRoundQuestion.where(question_id: @question.id).first.update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @other_question.id).first.update_attributes(vote_number: 10)
    @live_voting_round = FactoryGirl.create(:voting_round, :other, :live)
  end

  it "is linked to from the home page" do
    home = Home.new
    home.load
    home.should have_link("Voting for " + @voting_round.label, href: voting_round_path(@voting_round.id))
  end

  it "has links to previous and next voting rounds" do
    vr = ShowVotingRound.new
    vr.load(voting_round_id: @voting_round.id.to_s)
    vr.should have_link("Voting for " + @oldest_voting_round.label, href: voting_round_path(@oldest_voting_round.id))
    vr.should have_link("Voting for " + @live_voting_round.label, href: voting_round_path(@live_voting_round.id))
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
end

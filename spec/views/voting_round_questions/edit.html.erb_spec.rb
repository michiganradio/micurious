require 'spec_helper'

describe "voting_round_questions/edit" do
  before(:each) do
    @voting_round_question = assign(:voting_round_question, stub_model(VotingRoundQuestion,
      :voting_round_id => 1,
      :question_id => 1,
      :vote_number => 1
    ))
  end

  it "renders the edit voting_round_question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", voting_round_question_path(@voting_round_question), "post" do
      assert_select "input#voting_round_question_voting_round_id[name=?]", "voting_round_question[voting_round_id]"
      assert_select "input#voting_round_question_question_id[name=?]", "voting_round_question[question_id]"
      assert_select "input#voting_round_question_vote_number[name=?]", "voting_round_question[vote_number]"
    end
  end
end

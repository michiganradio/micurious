require 'spec_helper'

describe "voting_round_questions/show" do
  before(:each) do
    @voting_round_question = assign(:voting_round_question, stub_model(VotingRoundQuestion,
      :voting_round_id => 1,
      :question_id => 2,
      :vote_number => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end

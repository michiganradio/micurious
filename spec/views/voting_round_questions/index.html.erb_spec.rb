require 'spec_helper'

describe "voting_round_questions/index" do
  before(:each) do
    assign(:voting_round_questions, [
      stub_model(VotingRoundQuestion,
        :voting_round_id => 1,
        :question_id => 2,
        :vote_number => 3
      ),
      stub_model(VotingRoundQuestion,
        :voting_round_id => 1,
        :question_id => 2,
        :vote_number => 3
      )
    ])
  end

  it "renders a list of voting_round_questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

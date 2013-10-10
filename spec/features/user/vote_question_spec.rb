require 'spec_helper'

describe "Vote on a question" do
  subject { page }

  before(:each) do
    @question = FactoryGirl.create(:question)
    voting_round = FactoryGirl.create(:voting_round)
    voting_round.add_question(@question)
    visit root_path
  end

  specify "have vote link" do
    should have_link('Vote' + @question.id.to_s)
  end
end

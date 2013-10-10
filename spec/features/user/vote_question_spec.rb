require 'spec_helper'

describe "Vote on a question" do
  subject { page }

  before(:each) do
    @question = FactoryGirl.create(:question)
    @question2 = FactoryGirl.create(:question, :other)
    voting_round = FactoryGirl.create(:voting_round)
    voting_round.add_question(@question)
    voting_round.add_question(@question2)
    visit root_path
  end

  specify "have vote link" do
    should have_link('vote' + @question.id.to_s)
  end

  context "after voting" do   
    before { click_link('vote' + @question.id.to_s) }

    specify "error when try to vote twice" do
      page.driver.post(vote_path(question_id: @question.id))
      page.driver.status_code.should_not eq 200
    end

    specify "vote icons hidden" do
      should have_no_selector('vote' + @question.id.to_s)
      should have_no_selector('vote' + @question2.id.to_s)
    end

    specify "voted icon displayed next to voted on questio" do
      should have_selector('img#vote_confirm' + @question.id.to_s)
    end
  end
end

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
    should have_link('Vote' + @question.id.to_s)
  end

  context "after voting" do   
    before { click_link('Vote' + @question.id.to_s) }

    specify "error when try to vote twice" do
      page.driver.post(vote_path(question_id: @question.id))
      p page.driver.html
      p page.driver.follow_redirects?
      page.driver.status_code.should_not eq 200
    end

    specify "vote icons hidden when already voted" do
      should have_no_selector('Vote' + @question.id.to_s)
      should have_no_selector('Vote' + @question2.id.to_s)
    end
  end
end

require 'features/features_spec_helper'

describe 'visit widget page' do
  before do
    @voting_round = FactoryGirl.create(:voting_round)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question, display_text: "another text"), FactoryGirl.create(:question, display_text: "third text"), FactoryGirl.create(:question, display_text: "fourth text")]
    @voting_round.questions = @questions
    @widget_page = VotingWidget.new
    @widget_page.load
  end

  context "before voting" do
    it "has questions from active voting round" do
      @widget_page.questions[0].should have_text @questions.first.display_text
      @widget_page.questions[1].should have_text @questions.second.display_text
      @widget_page.widget_prompt.should have_text "Which would you rather know?"
      @widget_page.questions[0].should have_link('vote' + @questions.first.id.to_s)
      @widget_page.questions[1].should have_link('vote' + @questions.second.id.to_s)
    end

    it "only shows three questions" do
      expect(@widget_page.questions.size).to eq 3
    end
  end

  context "after voting" do

    before do
      @widget_page.vote_buttons[0].click
    end

    it "stays on widget page" do

    end

    it "hides vote buttons" do
      @widget_page.should_not have_vote_buttons
    end
  end
end

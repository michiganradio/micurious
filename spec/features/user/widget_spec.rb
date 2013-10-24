require 'features/features_spec_helper'

describe 'visit widget page' do
  before do
    @voting_round = FactoryGirl.create(:voting_round)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question, display_text: "another text"), FactoryGirl.create(:question, display_text: "third text"), FactoryGirl.create(:question, display_text: "fourth text")]
    @voting_round.questions = @questions
    VotingRoundQuestion.where(question_id: @questions[0].id).first.update_attributes(vote_number: 10)
    VotingRoundQuestion.where(question_id: @questions[1].id).first.update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @questions[2].id).first.update_attributes(vote_number: 5)
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

    describe "shows voting results" do
      it "hides vote buttons" do
        @widget_page.should_not have_vote_buttons
      end

      it "shows ranks" do
        @widget_page.questions[0].should have_text "1st"
        @widget_page.questions[1].should have_text "2nd"
        @widget_page.questions[2].should have_text "3rd"
      end

      it "orders questions by voting number" do
        @widget_page.questions[0].should have_text @questions[0].display_text
        @widget_page.questions[1].should have_text @questions[2].display_text
        @widget_page.questions[2].should have_text @questions[1].display_text
      end
    end
  end
end

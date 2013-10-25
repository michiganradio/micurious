require 'features/features_spec_helper'

describe 'visit voting widget page' do
  before do
    @voting_round = FactoryGirl.create(:voting_round)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question, display_text: "another text"), FactoryGirl.create(:question, display_text: "third text"), FactoryGirl.create(:question, display_text: "fourth text")]
    @voting_round.questions = @questions
    VotingRoundQuestion.where(question_id: @questions[0].id).first.update_attributes(vote_number: 10)
    VotingRoundQuestion.where(question_id: @questions[1].id).first.update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @questions[2].id).first.update_attributes(vote_number: 5)
    @vote_widget = VoteWidget.new
    @vote_widget.load
  end

  context "before voting" do
    it "has questions from active voting round" do
      @vote_widget.questions[0].should have_text @questions.first.display_text
      @vote_widget.questions[1].should have_text @questions.second.display_text
      @vote_widget.widget_prompt.should have_text "Which would you rather know?"
      @vote_widget.questions[0].should have_link('vote' + @questions.first.id.to_s)
      @vote_widget.questions[1].should have_link('vote' + @questions.second.id.to_s)
    end

    it "only shows three questions" do
      expect(@vote_widget.questions.size).to eq 3
    end
  end

  context "after voting" do

    before do
      @vote_widget.vote_buttons[0].click
    end

    describe "shows voting results" do
      it "hides vote buttons" do
        @vote_widget.should_not have_vote_buttons
      end

      it "shows ranks" do
        @vote_widget.questions[0].should have_text "1st"
        @vote_widget.questions[1].should have_text "2nd"
        @vote_widget.questions[2].should have_text "3rd"
      end

      it "orders questions by voting number" do
        @vote_widget.questions[0].should have_text @questions[0].display_text
        @vote_widget.questions[1].should have_text @questions[2].display_text
        @vote_widget.questions[2].should have_text @questions[1].display_text
      end
    end
  end
end

describe "visit ask widget page", js: true do

  it "allows user to submit a question" do
    @ask_widget = AskWidget.new
    @ask_widget.load
    @ask_widget.submit_question_text.set("What should this question be?")
    @ask_widget.ask_button.click
#    @home = Home.new
#    @home.should be_displayed
    #todo: check where the page has gone. (should bring up modal, go to home page)
  end

end

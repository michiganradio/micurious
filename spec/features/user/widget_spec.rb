require 'features/features_spec_helper'

describe 'visit widget page' do
  it "has questions from active voting round" do
    @voting_round = FactoryGirl.create(:voting_round)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question, display_text: "another text")]
    @voting_round.questions = @questions

    @widget_page = Widget.new

    @widget_page.load
    expect(@widget_page.has_number_of_questions? @voting_round.questions.size).to be_true
    @widget_page.questions[0].should have_text @questions.first.display_text
    @widget_page.questions[1].should have_text @questions.second.display_text
    @widget_page.widget_prompt.should have_text "Which would you rather know?"
    @widget_page.questions[0].should have_link('vote' + @questions.first.id.to_s)
    @widget_page.questions[1].should have_link('vote' + @questions.second.id.to_s)
  end

  it "only shows three questions" do
    @voting_round = FactoryGirl.create(:voting_round)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question, display_text: "another text"), FactoryGirl.create(:question, display_text: "third question"), FactoryGirl.create(:question, display_text: "fourth question")]
    @voting_round.questions = @questions
    @widget_page = Widget.new
    @widget_page.load
    expect(@widget_page.questions.size).to eq 3
  end
end

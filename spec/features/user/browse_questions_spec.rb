require 'features/features_spec_helper'

describe "browse questions" do

  it "displays all questions" do
    question = FactoryGirl.create(:question, created_at:1.day.ago)
    question2 = FactoryGirl.create(:question, :other, created_at:Time.now)
    @questions = Questions.new
    @questions.load
    @questions.should have(2).questions
    @questions.questions[0].text.should include question2.display_text
    @questions.questions[1].text.should include question.display_text
  end
end

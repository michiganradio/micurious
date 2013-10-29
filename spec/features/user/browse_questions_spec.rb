require 'features/features_spec_helper'

describe "browse questions" do
  describe "new and unanswered questions" do
    describe "all" do
      it "displays all unanswered questions by most recent" do
        question = FactoryGirl.create(:question, created_at:1.day.ago)
        question2 = FactoryGirl.create(:question, :other, created_at:Time.now)
        @questions = Questions.new
        @questions.load
        @questions.should have(2).questions
        @questions.questions[0].text.should include question2.display_text
        @questions.questions[1].text.should include question.display_text
      end
    end

    describe "by category" do
      it "displays all questions in category by most recent" do
        category = FactoryGirl.create(:category)
        question = FactoryGirl.create(:question, created_at: 1.day.ago,
                                      categories: [category])
        question2 = FactoryGirl.create(:question, :other,
                                       created_at: Time.now,
                                       categories: [category])
        question3 = FactoryGirl.create(:question,
                                       display_text: "display text 3",
                                       created_at: Time.now)
        @questions_in_category = Questions.new()
        @questions_in_category.load(category_id: category.id)
        @questions_in_category.should have(2).questions
        @questions_in_category.questions[0].text.should include question2.display_text
        @questions_in_category.questions[1].text.should include question.display_text
      end
    end
  end
end

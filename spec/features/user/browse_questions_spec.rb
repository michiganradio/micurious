require 'features/features_spec_helper'

describe "browse questions" do
  describe "new and unanswered questions" do
    describe "all" do
      it "displays all unanswered questions by most recent" do
        question = FactoryGirl.create(:question, created_at:1.day.ago)
        question2 = FactoryGirl.create(:question, :other, created_at:Time.now)
        @questions = Questions.new
        @questions.load
        @questions.should have(2).question_links
        @questions.question_links[0].text.should include question2.display_text
        @questions.question_links[1].text.should include question.display_text
        @questions.question_images[1][:src].should eq question.picture_url
        @questions.question_image_attribution_links[0][:href].should == question2.picture_attribution_url
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
        @questions_in_category = Questions.new
        @questions_in_category.load(category_name: category.name)
        @questions_in_category.should have(2).question_links
        @questions_in_category.question_links[0].text.should include question2.display_text
        @questions_in_category.question_links[1].text.should include question.display_text
      end
    end
  end

  describe "navigate to question detail page" do
    it "display the question detail info" do
      category = FactoryGirl.create(:category)
      question = FactoryGirl.create(:question, categories: [category])
      @questions_in_category = Questions.new
      @questions_in_category.load(category_name: category.name)
      @questions_in_category.question_links.first.click
      @question = ShowQuestion.new
      @question.should be_displayed
      @question.image[:src].should eq question.picture_url
      @question.attribution_link[:href].should == question.picture_attribution_url
    end
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "user browsing questions" do
  describe "questions/archive" do
    context "with no category selected" do
      it "displays all unanswered questions by most recent" do
        question = FactoryGirl.create(:question, created_at:1.day.ago)
        question2 = FactoryGirl.create(:question, :other, created_at:Time.now)
        @questions = Questions.new
        @questions.load(status: "archive")
        @questions.should have(2).question_links
        @questions.question_links[0].text.should include question2.display_text
        @questions.question_links[1].text.should include question.display_text
        @questions.question_images[1][:src].should include question.picture_url
      end
    end

    context "with a category chosen" do
      it "displays all questions in the category by most recent" do
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
        @questions_in_category.load(category_name: category.name, status: "archive")
        @questions_in_category.should have(2).question_links
        @questions_in_category.question_links[0].text.should include question2.display_text
        @questions_in_category.question_links[1].text.should include question.display_text
      end
    end
  end

  describe "questions/answered" do
    it "display all answered and investigating questions by most recent" do
      question1 = FactoryGirl.create(:question, status: Question::Status::Investigating)
      question2 = FactoryGirl.create(:question, status: Question::Status::Answered)
      question3 = FactoryGirl.create(:question, status: Question::Status::New)
      @questions = Questions.new
      @questions.load(status: "answered")
      @questions.should have(2).question_links
    end
  end

  describe "answered carousel in questions/answered" do
    it "displays featured questions" do
      question1 = FactoryGirl.create(:question, display_text: "text1", status: Question::Status::Answered, featured: true , reporter: "reporter1")
      question2 = FactoryGirl.create(:question, display_text: "text2", status: Question::Status::Investigating, featured: true, reporter: "reporter2" )
      question3 = FactoryGirl.create(:question, display_text: "text3", status: Question::Status::Answered, featured: false )
      @questions = Questions.new
      @questions.load(status: "answered")
      @questions.should have_content(question1.display_text)
      @questions.should have_content(question1.reporter)
      @questions.should have_content(question2.display_text)
      @questions.should have_content(question2.reporter)
    end
  end

  describe "questions/{id}" do
    it "displays the question's image, text, and answers/updates" do
      category = FactoryGirl.create(:category)
      question = FactoryGirl.create(:question, categories: [category])
      answer = FactoryGirl.create(:answer, question_id: question.id)
      update = FactoryGirl.create(:answer, :update, question_id: question.id)
      @questions_in_category = Questions.new
      @questions_in_category.load(status: "archive", category_name: category.name)
      @questions_in_category.question_links.first.click
      @question = ShowQuestion.new
      @question.should be_displayed
      @question.question_image[:src].should include question.picture_url
      @question.attribution_link[:href].should eq question.picture_attribution_url
      @question.answer_links[0].text.should eq answer.label
      @question.answer_links[0][:href].should eq answer.url
      @question.update_links[0].text.should eq update.label
      @question.update_links[0][:href].should eq update.url
      @question.should have_checkmark
    end

    it "has links to navigate to the other questions" do
      question0 = FactoryGirl.create(:question, :other)
      question1 = FactoryGirl.create(:question)
      question2 = FactoryGirl.create(:question, :other)
      @question = ShowQuestion.new
      @question.load(question_id: question1.id)
      @question.should have_link("Next Question", question_path(question1.id+1))
      @question.should have_link("Previous Question", question_path(question1.id-1))

      @question.load(question_id: question0.id)
      @question.should_not have_link("Previous Question")
      @question.should have_link("Next Question", question_path(question0.id+1))

      @question.load(question_id: question2.id)
      @question.should_not have_link("Next Question")
      @question.should have_link("Previous Question", question_path(question2.id-1))
    end
  end
end

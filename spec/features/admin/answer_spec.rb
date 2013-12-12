=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "/admin/answers/new{?question_id}" do
  def add_answer(answer_type)
    visit new_admin_answer_path(question_id: @question.id)
    @new_admin_answer_page = Admin::NewAnswer.new
    @new_admin_answer_page.load(question_id: @question.id)
    @new_admin_answer_page.answer_url_field.set "url"
    @new_admin_answer_page.answer_label_field.set "label"
    page.choose(answer_type) if answer_type
    @new_admin_answer_page.add_answer_button.click
  end

  before do
    signin_as_admin
    @question = FactoryGirl.create(:question)
  end

  describe "add answer" do
    context "when no answer type is selected" do
      it "displays error message" do
        add_answer(nil)
        @new_admin_answer_page.add_answer_to_question_errors[0].text.should ==
          "Type can't be blank"
      end
    end

    context "when an answer type is selected" do
      it "adds the answer" do
        add_answer(Answer::Type::Answer)
        @admin_answers_page = Admin::Answers.new
        @admin_answers_page.load(question_id: @question.id)
        @admin_answers_page.answers[0].url.text.should eq "url"
        @admin_answers_page.answers[0].label.text.should eq "label"
        @admin_answers_page.answers[0].type.text.should eq Answer::Type::Answer
      end

      it "adds the update" do
        add_answer(Answer::Type::Update)
        @admin_answers_page = Admin::Answers.new
        @admin_answers_page.load(question_id: @question.id)
        @admin_answers_page.updates[0].url.text.should eq "url"
        @admin_answers_page.updates[0].label.text.should eq "label"
        @admin_answers_page.updates[0].type.text.should eq Answer::Type::Update
      end
    end
  end

  describe "/admin/answers/{index}/edit" do
    it "allows changing of the fields" do
      answer = FactoryGirl.create(:answer, question_id: @question.id)
      visit edit_admin_answer_path(answer)
      @admin_answers_page = Admin::Answers.new
      @admin_answers_page.load(question_id: @question.id)
      @admin_answers_page.answers[0].edit_link.click
      @edit_admin_answer_page = Admin::EditAnswer.new
      @edit_admin_answer_page.load(answer_id: answer.id)
      @edit_admin_answer_page.answer_url_field.set "url2"
      @edit_admin_answer_page.answer_label_field.set "label2"
      page.choose(Answer::Type::Update)
      @edit_admin_answer_page.update_answer_button.click
      @admin_answers_page.load(question_id: @question.id)
      @admin_answers_page.updates[0].url.text.should eq "url2"
      @admin_answers_page.updates[0].label.text.should eq "label2"
      @admin_answers_page.updates[0].type.text.should eq Answer::Type::Update
    end
  end

  describe "delete link" do
    it "removes answer from the question" do
      answer = FactoryGirl.create(:answer, label: "label!!!", question_id: @question.id)
      @admin_answers_page = Admin::Answers.new
      @admin_answers_page.load(question_id: @question.id)
      @admin_answers_page.answers[0].delete_link.click
      @admin_answers_page.load(question_id: @question.id)
      @admin_answers_page.should_not have_answers
    end
  end
end

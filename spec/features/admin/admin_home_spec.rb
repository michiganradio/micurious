=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "/main" do
  subject { page }

  before do
  end

  it "has ten most recent questions" do
    @questions = FactoryGirl.create_list(:question, 11)
    @most_recent_questions = Question.order(updated_at: :desc).limit(11)
    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_questions[i].text.should eq "#{i+1}. "+ @most_recent_questions[i].display_text
    end
    @admin_home_page.should have_link("display text", href: admin_question_path(@most_recent_questions[1]))
    @admin_home_page.recent_questions.size.should eq 10
  end

  it "has ten most recent answers" do
    question = FactoryGirl.create(:question)
    @answers = FactoryGirl.create_list(:answer, 11, question_id: question.id, updated_at: "2013-11-20 12:38:40")
    @update = FactoryGirl.create(:answer, type: Answer::Type::Update, label: ";asldkfjals;dkfjsal;fdkjas;ldfjksa;lkdfj;aslkfjdlsfjalskdjf",  question_id: question.id)
    @most_recent_answers = Answer.where(type: "Answer").order(updated_at: :desc).limit(10)

    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_answers[i].text.should eq "#{i+1}. "+ @most_recent_answers[i].label
    end
    @admin_home_page.recent_answers.size.should eq 10
  end

  it "has ten most recent updates" do
    question = FactoryGirl.create(:question)
    @updates = FactoryGirl.create_list(:answer, 11, type: Answer::Type::Update, question_id: question.id, updated_at: "2013-11-20 12:38:40")
    @answer = FactoryGirl.create(:answer, type: Answer::Type::Answer, label: ";asldkfjals;dkfjsal;fdkjas;ldfjksa;lkdfj;aslkfjdlsfjalskdjf",  question_id: question.id)
    @most_recent_updates = Answer.where(type: "Update").order(updated_at: :desc).limit(10)

    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_updates[i].text.should eq "#{i+1}. "+ @most_recent_updates[i].label
    end
    @admin_home_page.should have_link("label", href: admin_question_path(@most_recent_updates[1].question_id))
    @admin_home_page.recent_updates.size.should eq 10
  end

  it "has ten most recent tags" do
    questions = FactoryGirl.create_list(:question, 11, tag_list: "tag", tags_updated_at: "2013-11-20 12:38:40")
    questions_without_updated_tags = FactoryGirl.create_list(:question, 5)

    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_tags[i].text.should have_content(questions[i].tags.join(", "))
    end
    @admin_home_page.should have_link("tag", href: admin_question_path(questions[0]))
    @admin_home_page.recent_tags.size.should eq 10
  end

  it "has ten most recent notes" do
    questions = FactoryGirl.create_list(:question, 11, notes_updated_at: "2013-11-20 12:38:40")
    questions_without_updated_notes = FactoryGirl.create_list(:question, 5)

    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_notes[i].text.should have_content(questions[i].notes)
    end
    @admin_home_page.recent_notes.size.should eq 10
  end

  it "has current voting round stats" do
    @voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
    @questions = [FactoryGirl.create(:question), FactoryGirl.create(:question), FactoryGirl.create(:question)]
    @voting_round.questions = @questions
    VotingRoundQuestion.where(question_id: @questions[0].id).first.update_attributes(vote_number: 10)
    VotingRoundQuestion.where(question_id: @questions[1].id).first.update_attributes(vote_number: 0)
    VotingRoundQuestion.where(question_id: @questions[2].id).first.update_attributes(vote_number: 5)
    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..2
      @admin_home_page.current_voting_round_questions[i].should have_content(@questions[i].display_text)
    end
  end

  it "displays search results" do
    category = FactoryGirl.create(:category, id: 100, active: true)
    @search_results = FactoryGirl.create_list(:question, 2, display_text: "This is a test", categories: [category])
    other_questions = FactoryGirl.create_list(:question, 3, display_text: "Apple")
    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    @admin_home_page.categories_dropdown.select(category.name)
    @admin_home_page.search_text_field.set("test")
    @admin_home_page.search_button.click

    @question_results_page = Admin::Results.new
    @question_results_page.search_question[0].should have_content(@search_results[0].display_text)
    @question_results_page.search_question[1].should have_content(@search_results[1].display_text)

  end
end

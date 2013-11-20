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
      @admin_home_page.recent_questions[i].text.should eq @most_recent_questions[i].display_text
    end
    @admin_home_page.recent_questions.size.should eq 10
  end

   it "has ten most recent answers" do
     question = FactoryGirl.create(:question)
    @answers = FactoryGirl.create_list(:answer, 11, question_id: question.id)
    @most_recent_answers = Answer.order(updated_at: :desc).limit(11)
    signin_as_admin
    @admin_home_page = Admin::Home.new
    @admin_home_page.load
    for i in 0..9
      @admin_home_page.recent_answers[i].text.should eq @most_recent_answers[i].label
    end
    @admin_home_page.recent_answers.size.should eq 10
  end
end

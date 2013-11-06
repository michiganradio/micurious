require 'features/features_spec_helper'

describe "Add answer to question" do
  def add_answer(answer_type)
    @new_admin_answer_page = Admin::NewAnswer.new
    @new_admin_answer_page.answer_url_field.set "url"
    @new_admin_answer_page.answer_label_field.set "label"
    page.choose(answer_type)
    @new_admin_answer_page.add_answer_button.click
  end

  def setup_show_question_page
    @show_admin_question_page = Admin::ShowQuestion.new
    @show_admin_question_page.load(id: @question.id)
  end

  before do
    signin_as_admin
    @question = FactoryGirl.create(:question)
    visit new_admin_answer_path(question_id: @question.id)
    @edit_admin_question_page = Admin::EditQuestion.new
    @edit_admin_question_page.load(id: @question.id)
    @edit_admin_question_page.new_answer_button.click
  end

  it "adds answer to question as admin" do
    add_answer(Answer::Type::Answer)
    setup_show_question_page
    @show_admin_question_page.answer_urls[0].text.should eq "url"
    @show_admin_question_page.answer_labels[0].text.should eq "label"
  end

  it "adds update to question as admin" do
    add_answer(Answer::Type::Update)
    setup_show_question_page
    @show_admin_question_page.update_urls[0].text.should eq "url"
    @show_admin_question_page.update_labels[0].text.should eq "label"
  end
end

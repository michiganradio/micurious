require 'features/features_spec_helper'

describe "Add answer to question" do
  it "adds answer to question as admin" do
    signin_as_admin
    @question = FactoryGirl.create(:question)
    visit new_admin_answer_path(question_id: @question.id)

    @edit_admin_question_page = Admin::EditQuestion.new
    @edit_admin_question_page.load(id: @question.id)
    @edit_admin_question_page.new_answer_button.click

    @new_admin_answer_page = Admin::NewAnswer.new
    @new_admin_answer_page.should be_displayed
    @new_admin_answer_page.answer_url_field.set "url"
    @new_admin_answer_page.answer_label_field.set "label"
    page.choose("Answer")
    @new_admin_answer_page.add_answer_button.click

    @show_admin_question_page = Admin::ShowQuestion.new
    @show_admin_question_page.should be_displayed
    @show_admin_question_page.load(id: @question.id)
    @show_admin_question_page.answer_urls[0].text.should eq "url"
    @show_admin_question_page.answer_labels[0].text.should eq "label"
  end
end

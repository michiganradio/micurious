require 'features/features_spec_helper'

describe 'Ask a question', js: true do

  def setup_ask_question_modal
    @home = Home.new
    @home.load
    @home.display_text.set "Why is the sky blue?"
    @home.ask_button.click
    @ask_question_modal = @home.ask_question_modal
  end

  def setup_confirm_question_modal
    @ask_question_modal.question_display_text.set("Why is the sky green?")
    @ask_question_modal.question_name.set("Robert Johnson")
    @ask_question_modal.question_anonymous.click
    @ask_question_modal.question_email.set("rjohnson@a.com")
    @ask_question_modal.question_email_confirmation.set("rjohnson@a.com")
    @ask_question_modal.question_neighbourhood.set("Bucktown")
    @ask_question_modal.question_categories[0].click
    @ask_question_modal.question_categories[1].click
    @ask_question_modal.modal_form_next.click
    @confirm_question_modal = @home.confirm_question_modal
  end

  describe "new question modal" do
    it "has title and prepopulated question" do
      setup_ask_question_modal
      @ask_question_modal.title.text.should == "Submit your question to Curious City"
      @ask_question_modal.question_display_text.text.should == "Why is the sky blue?"
    end
  end

  it "is shown when root_path is visited with anchor '#ask'" do
    @home = Home.new
    @home.load(anchor: "ask")
    @home.ask_question_modal.title.text.should == "Submit your question to Curious City"
  end

  describe "confirm question modal" do
    it "has expected content" do
      @category1 = FactoryGirl.create(:category)
      @category2 = FactoryGirl.create(:category, label: "MyString2")
      setup_ask_question_modal
      setup_confirm_question_modal
      @confirm_question_modal.title.should have_content "Double check that your question looks good"
      @confirm_question_modal.body.should have_content "Why is the sky green?"
      @confirm_question_modal.body.should have_content "Robert Johnson"
      @confirm_question_modal.body.should have_content "true"
      @confirm_question_modal.body.should have_content "rjohnson@a.com"
      @confirm_question_modal.body.should have_content "Bucktown"
      @confirm_question_modal.body.should have_content @category1.label
      @confirm_question_modal.body.should have_content @category2.label
      @confirm_question_modal.modal_form_submit
    end
  end

  describe "question received modal" do
    it "has question received content" do
      @category1 = FactoryGirl.create(:category)
      @category2 = FactoryGirl.create(:category, label: "MyString2")
      setup_ask_question_modal
      setup_confirm_question_modal
      @confirm_question_modal.modal_form_submit.click
      @question_received_modal = @home.question_received_modal
      @question_received_modal.title.text.should == "Thanks for submitting your question!"
    end
  end
end

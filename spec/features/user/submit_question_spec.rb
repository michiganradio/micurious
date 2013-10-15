require 'spec_helper'

describe 'Ask a question' do
  subject { page }

  before { visit root_path }

  context "main page" do
    describe "valid question" do
      before do
        find_by_id("display_text").set("Why is the sky blue?")
        click_button "Ask"
      end

      it { should have_content "Submit your question to Curious City" }
      it { should have_field("question_name") }
      it { should have_field("question_email") }
      it { should have_field("question_email_confirmation") }
      it { should have_field("question_neighbourhood") }
      it { page.find_by_id("question_display_text").should have_content "Why is the sky blue?" }
      it { should have_unchecked_field("question_anonymous") }
    end
  end

  context "new question page" do
    before do
      @category1 = FactoryGirl.create(:category)
      @category2 = FactoryGirl.create(:category, label: "MyString2")

      visit new_question_path

      fill_in('question_display_text', with: "Why is the sky green?")
      fill_in('question_name', with: "Robert Johnson")
      check('question_anonymous')

      fill_in('question_email', with: "rjohnson@a.com")
      fill_in('question_email_confirmation', with: "rjohnson@a.com")
      fill_in('question_neighbourhood', with: "Hell")

      check('question_category_id_' + @category1.id.to_s)
      check('question_category_id_' + @category2.id.to_s)
      click_button "NEXT"
    end

    specify "confirm details" do
      should have_content "Double check your question looks good:"
      should have_content "Why is the sky green?"
      should have_content "Robert Johnson"
      should have_content "true"
      should have_content "rjohnson@a.com"
      should have_content "Hell"
      should have_content @category1.label
      should have_content @category2.label
      should have_button "SUBMIT"
    end
  end
end

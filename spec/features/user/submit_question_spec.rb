require 'features/features_spec_helper'
require 'capybara/rails'

require 'selenium-webdriver'
Capybara.current_driver = :selenium

describe 'Ask a question', js: true do
  subject { page }

  before do
    DatabaseCleaner.clean
    visit root_path
    find_by_id("display_text").set("Why is the sky blue?")
    click_button "Ask"
  end

  describe "new question modal" do
    it "has title" do
      within('#myModal') do
        should have_content "Submit your question to Curious City"
      end
    end

    it "has question fields" do
      within('#myModal') do
        should have_field("question_display_text")
        should have_field("question_name")
        should have_field("question_email")
        should have_field("question_email_confirmation")
        should have_field("question_neighbourhood")
        should have_unchecked_field("question_anonymous")
      end
    end

    it "prepopulates display text field" do
      within('#myModal') do
        find_by_id("question_display_text").should have_content "Why is the sky blue?"
      end
    end

    it "has next button" do
      within('#myModal') do
        should have_selector("#modal-form-next")
      end
    end
  end

  describe "confirm question modal" do
    before do
      @category1 = FactoryGirl.create(:category)
      @category2 = FactoryGirl.create(:category, label: "MyString2")
      visit root_path
      find_by_id("display_text").set("Why is the sky blue?")
      click_button "Ask"

      within('#myModal') do
        fill_in('question_display_text', with: "Why is the sky green?")
        fill_in('question_name', with: "Robert Johnson")
        check('question_anonymous')

        fill_in('question_email', with: "rjohnson@a.com")
        fill_in('question_email_confirmation', with: "rjohnson@a.com")
        fill_in('question_neighbourhood', with: "Hell")

        check('question_category_id_' + @category1.id.to_s)
        check('question_category_id_' + @category2.id.to_s)
        click_link "modal-form-next"
      end
    end

    it "has title" do
      within('#myModal') do
        should have_content "Double check that your question looks good"
      end
    end

    it "displays question details" do
      within('#myModal') do
        should have_content "Why is the sky green?"
        should have_content "Robert Johnson"
        should have_content "true"
        should have_content "rjohnson@a.com"
        should have_content "Hell"
        should have_content @category1.label
        should have_content @category2.label
      end
    end

    it "has submit button" do
      within('#myModal') do
        should have_selector "#modal-form-submit"
      end
    end
  end
end

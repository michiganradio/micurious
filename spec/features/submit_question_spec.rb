require 'spec_helper'

describe 'Ask a question' do
  subject { page }
  
  before { visit root_path }

  describe "valid question" do
    before do
      find_by_id("question_text").set("Why is the sky blue?")
      click_button "Ask"
    end

    it { should have_content "New question" }
    it { should have_field("question_name") }
    it { should have_field("question_email") }
    it { should have_field("question_neighbourhood") }
  end
end

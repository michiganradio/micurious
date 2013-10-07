require 'spec_helper'

describe 'MainPage' do
  subject { page }
  
  before { visit root_path }

  describe "valid question" do
    before do
      find_by_id("question_text").set("Why is the sky blue?")
      click_button "Ask"
    end

    it { should have_title "Question details" }
  end
end

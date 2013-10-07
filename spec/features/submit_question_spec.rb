require 'spec_helper'

describe 'MainPage' do
  subject { page }
  
  context "Submit question" do
    before { visit root_path }

    describe "empty question" do
      before { click_button "Ask" }
      it { should have_selector('div.alert.alert-error', text: 'Question needs to be more than 0 characters.') }
    end
 
  end
end

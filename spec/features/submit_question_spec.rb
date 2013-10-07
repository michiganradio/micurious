require 'spec_helper'

describe 'MainPage' do
  subject { page }
  
  describe "Submit question" do
    before { visit root_path }

    it { should have_button "Submit" }

  end
end

require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit admin_signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { visit admin_questions_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:admin) { FactoryGirl.create(:user) }
      before do
        fill_in "Username", with: admin.username
        fill_in "Password", with: admin.password
        click_button "Sign in"
      end

      it { should have_content("Admin Home Page") }
      # it { should have_link('Sign out', href: signout_path) }
      # it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "Authentication" do

  subject { page }

  describe "/admin/signin" do
    before { visit admin_signin_path }

    context "with invalid information" do
      before { click_button "Sign in" }

      it { should have_content('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      context "after visiting another page" do
        before { visit admin_questions_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    context "with valid information" do
      let(:admin) { FactoryGirl.create(:user) }
      before do
        fill_in "Username", with: admin.username
        fill_in "Password", with: admin.password
        click_button "Sign in"
      end

      it { should have_content("Admin Home Page") }
    end
  end
end

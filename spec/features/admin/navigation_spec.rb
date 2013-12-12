=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "Admin Navigation" do
  subject { page }

  before { signin_as_admin }

  shared_examples_for "all admin pages" do
    describe "has navigation links" do
      it { should have_link("Dashboard", href: admin_path) }
      it { should have_link("Categories", href: admin_categories_path) }
      it { should have_link("Questions", href: admin_questions_path) }
      it { should have_link("Voting Rounds", href: admin_voting_rounds_path) }
      it { should have_link("Users", href: admin_users_path) }
      it { should have_link("Sign Out", href: admin_signout_path) }
    end
  end

  describe "/admin" do
    before do
      visit admin_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/signin" do
    before do
      visit admin_signin_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/categories" do
    before do
      visit admin_categories_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/categories/new" do
    before do
      visit new_admin_category_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/categories/{index}/edit" do
    before do
      category = FactoryGirl.create(:category)
      visit edit_admin_category_path(category.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/categories/{index}" do
    before do
      category = FactoryGirl.create(:category)
      visit admin_category_path(category.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/questions" do
    before do
      visit admin_questions_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/questions/new" do
    before do
      visit new_admin_question_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/questions/{index}/edit" do
    let(:question) { FactoryGirl.create(:question) }

    before do
      visit edit_admin_question_path(question.id)
    end

    it { should have_link("Answers", href: admin_answers_path(question_id: question.id)) }
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/questions/{index}" do
    before do
      question = FactoryGirl.create(:question)
      visit admin_question_path(question.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/voting_rounds" do
    before do
      visit admin_voting_rounds_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/voting_rounds/new" do
    before do
      visit new_admin_voting_round_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/voting_rounds/{index}/edit" do
    before do
      voting_round = FactoryGirl.create(:voting_round)
      visit edit_admin_voting_round_path(voting_round.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/voting_rounds/{index}" do
    before do
      voting_round = FactoryGirl.create(:voting_round)
      visit admin_voting_round_path(voting_round.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/users" do
    before do
      visit admin_users_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/users/new" do
    before do
      visit new_admin_user_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/users/{index}/edit" do
    before do
      user = FactoryGirl.create(:user, username: "user2")
      visit edit_admin_user_path(user.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "/admin/users/{index}" do
    before do
      user = FactoryGirl.create(:user, username: "user1")
      visit admin_user_path(user.id)
    end
    it_should_behave_like 'all admin pages'
  end


end

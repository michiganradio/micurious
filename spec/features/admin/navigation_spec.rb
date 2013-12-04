require 'features/features_spec_helper'

describe "Admin navigation" do
  subject { page }

  before { signin_as_admin }

  shared_examples_for "all admin pages" do
    describe "has navigation links" do
      it { should have_link("Dashboard", href: admin_path) }
      it { should have_link("Categories", href: admin_categories_path) }
      it { should have_link("Questions", href: admin_questions_path) }
      it { should have_link("Voting Rounds", href: admin_voting_rounds_path) }
      it { should have_link("Users", href: admin_users_path) }
    end
  end

  describe "dashboard page" do
    before do
      visit admin_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "signin page" do
    before do
      visit admin_signin_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "categories page" do
    before do
      visit admin_categories_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "new category page" do
    before do
      visit new_admin_category_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "edit category page" do
    before do
      category = FactoryGirl.create(:category)
      visit edit_admin_category_path(category.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "show category page" do
    before do
      category = FactoryGirl.create(:category)
      visit admin_category_path(category.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "questions page" do
    before do
      visit admin_questions_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "new question page" do
    before do
      visit new_admin_question_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "edit question page" do
    let(:question) { FactoryGirl.create(:question) }

    before do
      visit edit_admin_question_path(question.id)
    end

    it { should have_link("Answers", href: admin_answers_path(question_id: question.id)) }
    it_should_behave_like 'all admin pages'
  end

  describe "show question page" do
    before do
      question = FactoryGirl.create(:question)
      visit admin_question_path(question.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "voting rounds page" do
    before do
      visit admin_voting_rounds_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "new voting round page" do
    before do
      visit new_admin_voting_round_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "edit voting round page" do
    before do
      voting_round = FactoryGirl.create(:voting_round)
      visit edit_admin_voting_round_path(voting_round.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "show voting round page" do
    before do
      voting_round = FactoryGirl.create(:voting_round)
      visit admin_voting_round_path(voting_round.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "show admin dashboard page" do
    before do
      visit admin_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "users page" do
    before do
      visit admin_users_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "new user page" do
    before do
      visit new_admin_user_path
    end
    it_should_behave_like 'all admin pages'
  end

  describe "edit user page" do
    before do
      user = FactoryGirl.create(:user, username: "user2")
      visit edit_admin_user_path(user.id)
    end
    it_should_behave_like 'all admin pages'
  end

  describe "show user page" do
    before do
      user = FactoryGirl.create(:user, username: "user1")
      visit admin_user_path(user.id)
    end
    it_should_behave_like 'all admin pages'
  end


end

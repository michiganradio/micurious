require 'spec_helper'

describe "QuestionEditPage" do
  subject { page }
  let (:question){ FactoryGirl.create(:question) }

  describe "add question to voting round" do
    before { FactoryGirl.create(:voting_round) }
    before { visit edit_admin_question_path(question) }

    it { should have_button "Add question to voting round" }

    describe "goes to voting round profile" do
      before { click_button('Add question to voting round') }
      it { should have_content("success") }
    end
  end
end

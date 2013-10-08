require 'spec_helper'

describe "welcome" do
  describe "GET home" do
    it "shows the current voting round questions" do
      voting_round = FactoryGirl.create(:voting_round)
      voting_round.add_question(FactoryGirl.create(:question))

      get root_path
      expect(response.body).to include voting_round.questions.first.display_text

    end
  end
end

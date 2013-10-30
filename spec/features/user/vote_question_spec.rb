require 'features/features_spec_helper'

describe "Vote on a question" do
  subject { page }

  before do
    @question = FactoryGirl.create(:question)
    @question2 = FactoryGirl.create(:question, :other)
    @voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
    @voting_round.add_question(@question)
    @voting_round.add_question(@question2)
    visit root_path
  end

  specify "have vote link" do
    should have_link('vote' + @question.id.to_s)
  end

  specify "display question image" do
    expect(page.all(:css, ".question-image img")[0][:src]).to eq @question.picture_url
    expect(page.all(:css, ".question-image img")[1][:src]).to eq @question2.picture_url
  end

  context "after voting" do
    before { click_link('vote' + @question.id.to_s) }

    specify "error when try to vote twice" do
      page.driver.post(vote_path(question_id: @question.id))
      page.driver.status_code.should_not eq 200
    end

    specify "vote icons hidden" do
      should have_no_selector('vote' + @question.id.to_s)
      should have_no_selector('vote' + @question2.id.to_s)
    end

    specify "voted icon displayed next to voted-on question" do
      should have_selector('div#vote_confirm' + @question.id.to_s)
    end
  end

  context "new voting round" do
    before do
      click_link('vote' + @question.id.to_s)
      # FIXME: change this step when the complete voting round is done
      @voting_round.status = VotingRound::Status::Completed
      @voting_round.save!
      @new_question = FactoryGirl.create(:question, display_text: "hi")
      new_voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
      new_voting_round.add_question(@new_question)
      visit(current_path)
    end

    specify "have vote link" do
      should have_link('vote' + @new_question.id.to_s)
    end

    specify "voted icon not displayed" do
      should_not have_selector('div#vote_confirm' + @new_question.id.to_s)
    end
  end

  context "ordering" do
    context "before voting" do
      specify "by id from least to greatest" do
        body.should =~ /question#{@question.id}.*question#{@question2.id}/m
      end

      specify "ranks not displayed" do
        should_not have_selector("h2#rank#{@question.id}")
        should_not have_selector("h2#rank#{@question2.id}")
      end
    end

    context "after voting" do
      before { click_link('vote' + @question2.id.to_s) }

      specify "by number of votes from greatest to least" do
        body.should =~ /question#{@question2.id}.*question#{@question.id}/m
      end

      specify "ranks displayed" do
        should have_selector("h2#rank#{@question.id}", text: "2nd")
        should have_selector("h2#rank#{@question2.id}", text: "1st")
      end
    end
  end
end

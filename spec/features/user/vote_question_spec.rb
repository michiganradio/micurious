require 'features/features_spec_helper'

describe "Vote on a question" do
  subject { page }

  before do
    @question = FactoryGirl.create(:question)
    @question2 = FactoryGirl.create(:question, :other)
    @voting_round = FactoryGirl.create(:voting_round, status: VotingRound::Status::Live)
    @voting_round.add_question(@question)
    @voting_round.add_question(@question2)
    Array.any_instance.stub(:shuffle).and_return([@question, @question2])
    @home = Home.new
    @home.load
  end

  specify "have links" do
    @home.voting_round.vote_links[0][:href].should eq vote_path(question_id: @question.id, voting_round_id: @voting_round.id)
    @home.voting_round.vote_links[1][:href].should eq vote_path(question_id: @question2.id, voting_round_id: @voting_round.id)

    @home.voting_round.question_links[0].text.should eq @question.display_text
    @home.voting_round.question_links[0][:href].should eq question_url(@question.id)
    @home.voting_round.question_links[1].text.should eq @question2.display_text
    @home.voting_round.question_links[1][:href].should eq question_url(@question2.id)

    @home.voting_round.picture_links[0].text.should eq @question.picture_owner
    @home.voting_round.picture_links[0][:href].should eq @question.picture_attribution_url
    @home.voting_round.picture_links[1].text.should eq @question2.picture_owner
    @home.voting_round.picture_links[1][:href].should eq @question2.picture_attribution_url
  end

  specify "display question image" do
    @home.voting_round.pictures[0][:src].should include @question.picture_url
    @home.voting_round.pictures[1][:src].should include @question2.picture_url
  end

  context "after voting" do
    before { @home.voting_round.vote_links[0].click }

    specify "vote icons hidden" do
      @home.voting_round.should_not have_vote_links
    end

    specify "voted icon displayed next to voted-on question" do
      @home.voting_round.vote_confirm[:id].should eq "vote_confirm" + @question.id.to_s
    end
  end

  context "new voting round" do
    before do
      @home.voting_round.vote_links[0].click
      @voting_round.status = VotingRound::Status::Completed
      @voting_round.save!
      @new_question = FactoryGirl.create(:question, display_text: "hi")
      @new_voting_round = FactoryGirl.create(:voting_round, :other, status: VotingRound::Status::New)
      @new_voting_round.add_question(@new_question)
      @new_voting_round.status = VotingRound::Status::Live
      @new_voting_round.save
      Array.any_instance.stub(:shuffle).and_return([@new_question])
      @home.load
    end

    specify "have vote link" do
      @home.voting_round.vote_links[0][:href].should eq vote_path(question_id: @new_question.id, voting_round_id: @new_voting_round.id)
    end

    specify "voted icon not displayed" do
      @home.voting_round.should_not have_vote_confirm
    end
  end

  context "ordering" do
    context "before voting" do
      specify "ranks not displayed" do
        @home.voting_round.should_not have_ranks
      end
    end

    context "after voting" do
      before { @home.voting_round.vote_links[1].click }

      specify "ranks displayed in order by vote number" do
        @home.voting_round.ranks.size.should eq 2
        @home.voting_round.ranks[0][:id].should eq "rank#{@question2.id}"
        @home.voting_round.ranks[0].text.should eq "1st"
        @home.voting_round.ranks[1][:id].should eq "rank#{@question.id}"
        @home.voting_round.ranks[1].text.should eq "2nd"
      end
    end
  end
end

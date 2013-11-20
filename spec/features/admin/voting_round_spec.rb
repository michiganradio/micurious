require 'features/features_spec_helper'

describe "admin's voting round actions" do

  before { signin_as_admin }

  describe "create new voting round" do
    before do
      @new_admin_voting_round_page = Admin::NewVotingRound.new
      @new_admin_voting_round_page.load
      @public_label_text = "public label text"
    end

    context "when public label field is not empty" do
      before do
        @new_admin_voting_round_page.public_label.set @public_label_text
        @new_admin_voting_round_page.create_button.click
      end

      it "displays public label on index page" do
        @show_admin_voting_round_page = Admin::ShowVotingRound.new
        @show_admin_voting_round_page.load(id: VotingRound.last.id)
        @show_admin_voting_round_page.public_label.text.should == @public_label_text
      end

      it "displays public label on voting round show page" do
        @admin_voting_rounds_page = Admin::VotingRounds.new
        @admin_voting_rounds_page.load
        expect(@admin_voting_rounds_page.has_public_label? /#{@public_label_text }/).to be_true
      end
    end

    context "when public_label field is empty" do
      before do
        @new_admin_voting_round_page.create_button.click
        @default_public_label_text = "Voting Round #{VotingRound.last.id}"
      end

      it "displays default public label text on index page" do
        @show_admin_voting_round_page = Admin::ShowVotingRound.new
        @show_admin_voting_round_page.load(id: VotingRound.last.id)
        @show_admin_voting_round_page.public_label.text.should == @default_public_label_text
      end

      it "displays default public label text on voting round show page" do
        @admin_voting_rounds_page = Admin::VotingRounds.new
        @admin_voting_rounds_page.load
        expect(@admin_voting_rounds_page.has_public_label? /#{@default_public_label_text}/).to be_true
      end
    end
  end

  describe "edit voting round" do
    context "when label is changed" do
      before do
        @voting_round = FactoryGirl.create(:voting_round)
        @edit_admin_voting_round_page = Admin::EditVotingRound.new
        @edit_admin_voting_round_page.load(id: @voting_round.id)
        @edit_admin_voting_round_page.public_label.set "new public label text"
        @edit_admin_voting_round_page.update_button.click
      end

      it "displays updated public label text on voting round show page" do
        @show_admin_voting_round_page = Admin::ShowVotingRound.new
        @show_admin_voting_round_page.load(id: @voting_round.id)
        @show_admin_voting_round_page.public_label.text.should == "new public label text"
      end
    end
  end
end

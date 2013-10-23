require 'features/features_spec_helper'

describe "Manage voting round" do

  describe "create new voting round" do
    before do
      @new_admin_voting_round_page = Admin::NewVotingRound.new
      @new_admin_voting_round_page.load
      @label_text = "label text"
    end

    context "label field filled in" do
      before do
        @new_admin_voting_round_page.label.set @label_text
        @new_admin_voting_round_page.create_button.click
      end

      it "displays label on index page" do
        @show_admin_voting_round_page = Admin::ShowVotingRound.new
        @show_admin_voting_round_page.load(id: VotingRound.last.id)
        @show_admin_voting_round_page.label.text.should == @label_text
      end

      it "displays label on voting round show page" do
        @admin_voting_rounds_page = Admin::VotingRounds.new
        @admin_voting_rounds_page.load
        expect(@admin_voting_rounds_page.has_label? /#{@label_text }/).to be_true
      end
    end

    context "label field not filled in" do
      before do
        @new_admin_voting_round_page.create_button.click
        @default_label_text =  "Voting Round " + VotingRound.last.id.to_s
      end

      it "displays label on index page" do
        @show_admin_voting_round_page = Admin::ShowVotingRound.new
        @show_admin_voting_round_page.load(id: VotingRound.last.id)
        @show_admin_voting_round_page.label.text.should == @default_label_text
      end

      it "displays label on voting round show page" do
        @admin_voting_rounds_page = Admin::VotingRounds.new
        @admin_voting_rounds_page.load
        expect(@admin_voting_rounds_page.has_label? /#{@default_label_text}/).to be_true
      end

    end
  end

  describe "edit voting round label" do
    before do
      @voting_round = FactoryGirl.create(:voting_round)
      @edit_admin_voting_round_page = Admin::EditVotingRound.new
      @edit_admin_voting_round_page.load(id: @voting_round.id)
      @edit_admin_voting_round_page.label.set "new label text"
      @edit_admin_voting_round_page.update_button.click
    end

    it "displays new label text on voting round show page" do
      @show_admin_voting_round_page = Admin::ShowVotingRound.new
      @show_admin_voting_round_page.load(id: @voting_round.id)
      @show_admin_voting_round_page.label.text.should ==
          "new label text"
    end
  end
end

describe "QuestionEditPage" do
  describe "add question to voting round by label" do
    before do
      @question = FactoryGirl.create(:question)
      @voting_round = FactoryGirl.create(:voting_round)
      FactoryGirl.create(:voting_round)
      @edit_admin_question_page = Admin::EditQuestion.new
    end

    it "has add question to voting round button" do
      @edit_admin_question_page.load(id: @question.id)
      @edit_admin_question_page.has_add_question_to_voting_round_button?.should be_true
    end

    describe "add button clicked" do
      context "active question" do
        before do
          @edit_admin_question_page.load(id: @question.id)
          @edit_admin_question_page.label_dropdown.select(@voting_round.label)
          @edit_admin_question_page.add_question_to_voting_round_button.click
        end

        it "displays confirmation message" do
          @edit_admin_question_page.add_question_to_voting_round_confirmation.text.should ==
            "Question was successfully added to the voting round"
        end

        it "displays added question on voting round page" do
          @show_admin_voting_round_page = Admin::ShowVotingRound.new
          @show_admin_voting_round_page.load(id: @voting_round.id)
          expect(@show_admin_voting_round_page.has_question? /#{@question.display_text}/).to be_true
        end
      end

      context "deactivated question" do
        before do
          @deactivated_question = FactoryGirl.create(:question, active: false)
          @edit_admin_question_page_deactivated = Admin::EditQuestion.new
          @edit_admin_question_page_deactivated.load(id: @deactivated_question.id)
        end

        it "displays error message" do
          @edit_admin_question_page.label_dropdown.select(@voting_round.label)
          @edit_admin_question_page_deactivated.add_question_to_voting_round_button.click
          @edit_admin_question_page_deactivated.add_question_to_voting_round_error.text.should ==
            "Deactivated question can not be added to voting round"
        end
      end
    end
  end
end

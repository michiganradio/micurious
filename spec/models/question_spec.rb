require 'spec_helper'

describe Question do
  subject { @question }

  context "original_text" do
    before do
      @question = FactoryGirl.create(:question)
    end

    it "no updating the original_text" do
      original_text = @question.original_text
      @question.update_attributes :original_text => original_text + "new"
      @question.reload.original_text.should eql original_text
    end

    its('original_text') { should eq @question.display_text }

    describe "picture_url" do
      context "question is not new" do
        context "picture_url is blank" do
          it "should be default" do
            default_picture_url = "/assets/default-question-picture.jpg"
            @question.update_attributes picture_url: ""
            @question.reload.picture_url.should eq default_picture_url
          end
        end

        context "picture_url is NOT blank" do
          it "should be picture_url" do
            @question.update_attributes picture_url: "url"
            @question.reload.picture_url.should eq "url"
          end
        end
      end

      context "question is new" do
        it "should be picture_url" do
          question = Question.new
          question.picture_url.should eq question.read_attribute(:picture_url)
        end
      end
    end
  end

  context "validation" do
    before do
      @question = FactoryGirl.build(:question)
    end

    context "display_text" do

      it { should respond_to(:display_text) }
      it { should ensure_length_of(:display_text).
            is_at_least(1).
            is_at_most(140) }
    end

    context "neighborhood" do
      it { should ensure_length_of(:neighbourhood).is_at_most(255) }

      it "is not valid with special characters" do
        @question.neighbourhood = "&dddd"
        @question.should_not be_valid
      end

      it "is valid with letters, spaces,slashes, commas, apostrophes, parentheses, dashes,  and periods" do
        @question.neighbourhood = "Ddddd.(),'-/ D"
        @question.should be_valid
      end
    end

    context "name" do
      it { should ensure_length_of(:name).is_at_least(1).is_at_most(255) }

      it "is not valid with special characters" do
        @question.name = "$$%^&*((((dddd"
        @question.should_not be_valid
        @question.errors[:name].first.should eq "only allows letters, spaces, periods, hyphens, apostrophes, and @ signs"
      end

      it "is valid with letters and spaces" do
        @question.name = "Ddddd D"
        @question.should be_valid
      end

      it "is valid with period and parentheses" do
        @question.name = "abc.()"
        @question.should be_valid
      end

      it "is valid with hyphens" do
        @question.name = "abc-"
        @question.should be_valid
      end

      it "is valid with apostrophes" do
        @question.name = "abc'"
        @question.should be_valid
      end

      it "is valid with @" do
        @question.name = "abc@"
        @question.should be_valid
      end
    end

    context "email" do
      it { should ensure_length_of(:email).is_at_most(255)}

      it "is not valid with different email confirmation" do
        @question.email = "email@email.com"
        @question.email_confirmation = "email@email.confirmation.com"
        @question.should_not be_valid
      end

      it "is valid with the same email confirmation" do
        @question.email = "email@email.com"
        @question.email_confirmation = "email@email.com"
        @question.should be_valid
      end
    end
  end

  context "display_author" do
    context "when the question is submitted anonymously" do
      it "displays the name" do
        @question = FactoryGirl.build(:question, :anonymous)
        @question.display_author.should == Question::ANONYMOUS
      end
    end

    context "when the question is not submitted anonymously" do
      it "displays the name" do
        @question = FactoryGirl.build(:question)
        @question.display_author.should == @question.name
      end
    end
  end

  describe "in_active_voting_rounds?" do
    context "not in any voting round" do
      it "returns false" do
        @question = FactoryGirl.build(:question)
        @question.in_active_voting_rounds?.should be_false
      end
    end

    context "in one voting round" do
      context "voting round is new" do
        it "returns true" do
          voting_round = FactoryGirl.build(:voting_round,  status:VotingRound::Status::New)
          @question = FactoryGirl.build(:question)
          @question.voting_rounds = [voting_round]

          @question.in_active_voting_rounds?.should be_true
        end
      end
      context "voting round is live" do
        it "return true" do
            voting_round = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Live)
            @question = FactoryGirl.build(:question)
            @question.voting_rounds = [voting_round]

            @question.in_active_voting_rounds?.should be_true
        end
      end
      context "voting round is completed" do
        it "return false" do
            voting_round = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Completed)
            @question = FactoryGirl.build(:question)
            @question.voting_rounds = [voting_round]

            @question.in_active_voting_rounds?.should be_false
        end
      end
      context "voting round is deactivated" do
        it "return false" do
            voting_round = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Deactivated)
            @question = FactoryGirl.build(:question)
            @question.voting_rounds = [voting_round]

            @question.in_active_voting_rounds?.should be_false
        end
      end
    end

    context "in multiple voting rounds" do
      context "none of the voting rounds is new, or live" do
        it "returns false" do
          voting_round1 = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Deactivated)
          voting_round2 = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Completed)
          @question = FactoryGirl.build(:question)
          @question.voting_rounds = [voting_round1, voting_round2]

          @question.in_active_voting_rounds?.should be_false

        end
      end

      context "one of the voting rounds is new" do
        it "returns true" do
          voting_round1 = FactoryGirl.build(:voting_round,  status:VotingRound::Status::Deactivated)
          voting_round2 = FactoryGirl.build(:voting_round,  status:VotingRound::Status::New)
          @question = FactoryGirl.build(:question)
          @question.voting_rounds = [voting_round1, voting_round2]

          @question.in_active_voting_rounds?.should be_true
        end
      end
    end
  end

  describe "with_status_and_category" do
    it "filters by status, category, and order by created_at desc" do
      category1 =  FactoryGirl.create(:category)
      category2 = FactoryGirl.create(:category, name: "some other")
      question1 = FactoryGirl.create(:question, categories: [category1],
                                     status: Question::Status::New,  created_at: 1.day.ago)
      question2 = FactoryGirl.create(:question,
                                     status: Question::Status::New, categories: [category1])
      question3 = FactoryGirl.create(:question,
                                     status: Question::Status::Investigating,
                                     categories: [category1])
      question4 = FactoryGirl.create(:question,
                                     status: Question::Status::New, categories: [category2])
      Question.with_status_and_category([Question::Status::New ], category1.name).should == [question2, question1]
    end

    it "filters by status and order" do
      category1 = FactoryGirl.create(:category)
      category2 = FactoryGirl.create(:category, name: "some other")

      question1= FactoryGirl.create(:question, categories: [category1],
                                   status: Question::Status::Investigating)

      question2= FactoryGirl.create(:question, categories: [category2],
                                   status: Question::Status::Investigating)

      question3= FactoryGirl.create(:question, categories: [category2],
                                   status: Question::Status::New)

      Question.with_status_and_category([Question::Status::Investigating], nil).should == [question1, question2]
    end

  end

  describe "active?" do
    it "is true when the status is New, Investigating, and Answered" do
      [Question::Status::New, Question::Status::Investigating, Question::Status::Answered].each do |status|
        question = FactoryGirl.build(:question, status: status)
        question.active?.should be_true
      end
    end

    it "is false when the status is Removed" do
      question = FactoryGirl.build(:question, status: Question::Status::Removed)
      question.active?.should be_false
    end
  end
end

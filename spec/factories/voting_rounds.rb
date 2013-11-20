# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :voting_round do
    start_time "2013-10-03 11:03:52"
    end_time "2013-10-03 11:03:52"
    public_label "public label"
    private_label "private label"

    trait :other do
      start_time "2014-01-01 03:04:11"
      end_time "2014-01-01 03:04:11"
      public_label "other public label"
      private_label "other private label"
    end

    trait :live do
      status VotingRound::Status::Live
    end

    trait :completed do
      status VotingRound::Status::Completed
    end
  end
end

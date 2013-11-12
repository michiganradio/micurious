# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence(:label) { |n| "label text #{n}" }

  factory :voting_round do
    start_time "2013-10-03 11:03:52"
    end_time "2013-10-03 11:03:52"
    label "Voting Round 1"

    trait :other do
      label "Other Voting Round"
    end

    trait :live do
      status VotingRound::Status::Live
    end

    trait :completed do
      status VotingRound::Status::Completed
    end
  end
end

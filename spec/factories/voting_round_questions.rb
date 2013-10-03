# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voting_round_question do
    voting_round_id 1
    question_id 1
    vote_number 1
  end
end

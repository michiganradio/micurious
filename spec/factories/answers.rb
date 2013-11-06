# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    label "label"
    url "url"
    question nil
    type Answer::Type::Answer

    trait :update do
      type Answer::Type::Update
    end
  end
end

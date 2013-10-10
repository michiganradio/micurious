FactoryGirl.define do
  factory :question do
    display_text  "display_text"
    name "Questioner_name"
    categories []

    trait :anonymous do
      anonymous true
      name "Anon_name"
    end

    trait :other do
      display_text "display_text2"
      name "Questioner_name2"
    end
  end
end


FactoryGirl.define do
  factory :question do
    display_text  "display_text"
    name "Questioner name"
    neighbourhood "lake view"
    email "a@email.com"

    categories []

    trait :anonymous do
      anonymous true
      name "Anon name"
    end

    trait :other do
      display_text "display_text2"
      name "Questioner namee"
    end
  end
end


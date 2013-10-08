FactoryGirl.define do
  factory :question do
    display_text  "display_text"
    name "Questioner_name"
    
    trait :anonymous do
      anonymous true
      name "Anon_name"
    end
  end
end


FactoryGirl.define do
  factory :question do
    display_text  "display_text"
    name "Questioner name"
    neighbourhood "lake view"
    email "a@email.com"
    email_confirmation "a@email.com"
    picture_url "url"
    picture_owner "owner"
    categories []

    trait :anonymous do
      anonymous true
      name "Anon name"
    end

    trait :other do
      display_text "display_text2"
      name "Questioner namee"
      neighbourhood "deerfield"
      email "b@email.com"
      email_confirmation "b@email.com"
      picture_url "url2"
      picture_owner "owner2"
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "MyString"
    password "password"
    password_confirmation "password"
    admin true
    trait :reporter do
      admin false
    end
  end
end

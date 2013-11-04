# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    label "MyString"
    url "MyString"
    question nil
  end
end

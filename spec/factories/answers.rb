# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    label "label"
    url "url"
    question nil
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category, :class => 'Category' do
    name "MyString"
    label "MyString"
    active false

    trait :other do
      name "secondName"
      label "second name"
      active true
    end
  end
end

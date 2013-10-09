# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category, :class => 'Category' do
    name "MyString"
    label "MyString"
    active false
  end
end

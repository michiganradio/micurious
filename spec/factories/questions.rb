=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
FactoryGirl.define do
  factory :question do
    sequence(:display_text) { |n| "display text #{n}" }
    sequence(:notes) { |n| "note #{n}" }
    name "Questioner name"
    neighbourhood "lake view"
    email "a@email.com"
    email_confirmation "a@email.com"
    picture_url "url"
    picture_owner "owner"
    picture_attribution_url "attribution_url"
    categories []
    tag_list "some tags"
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
      picture_attribution_url "attribution_url2"
    end
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :voting_round do
    start_time "2013-10-03 11:03:52"
    end_time "2013-10-03 11:03:52"

    trait :other do
      start_time "2014-01-01 03:04:11"
      end_time "2014-01-01 03:04:11"
    end

    trait :live do
      status VotingRound::Status::Live
    end

    trait :completed do
      status VotingRound::Status::Completed
    end
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Answer < ActiveRecord::Base
  belongs_to :question
  acts_as_list :scope => :question

  validates :label, length: { maximum: 3000, minimum: 1 }
  validates :url, length: { maximum: 2000, minimum: 1 }
  validates :type, presence: true
  self.inheritance_column = :_type_disabled

  def self.recent_answers
    where(type: "Answer").order(updated_at: :desc).limit(10)
  end

  def self.recent_updates
    where(type: "Update").order(updated_at: :desc).limit(10)
  end

  module Type
    Answer = "Answer"
    Update = "Update"
    All = [Answer, Update]
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Admin::QuestionsHelper do
  describe "display_tags" do
    it "concats tag names with comma" do
      question= Question.new
      question.tag_list = "a, b, c"
      helper.display_tags(question).should == "a, b, c"
    end
  end

  describe "display_date" do
    it "converts the date to MonddYYYY format" do
      date = DateTime.new(2013, 3, 4, 0, 0, 0)
      helper.display_date(date).should == "03/04/2013"
    end
  end
end

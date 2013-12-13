=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe QuestionsHelper do

  describe "#cache_key_for_questions" do
    it "returns a key based on the requests params and results" do
      last_updated_at = Time.now
      questions = double(:question, count: 2)
      questions.stub(:maximum).with(:updated_at).and_return(last_updated_at)
      helper.stub(:params).and_return({:status => "status",
                                       :category_name => "category_name", :page => "page"})
      helper.cache_key_for_questions(questions).should == "questions-status-category_name-2-#{last_updated_at.utc.to_s(:number)}-page"
    end
  end
end

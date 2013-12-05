=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Answer do
  describe "validation" do
    context "label" do
      it { should ensure_length_of(:label).
            is_at_least(1).
            is_at_most(3000) }
    end

    context "url" do
      it { should ensure_length_of(:url).
           is_at_least(1).
           is_at_most(2000) }
    end

    context "type" do
      it { should validate_presence_of(:type) }
    end
  end

  describe "recent_answer" do
      it "returns recent updated answers" do
        @most_recent_answers = [Answer.new]
        Answer.stub_chain(:where, :order, :limit).and_return(@most_recent_answers)
        Answer.recent_answers.should == @most_recent_answers
      end
  end

  describe "recent_update" do
      it "returns recent updated updates" do
        @most_recent_updates = [Answer.new]
        Answer.stub_chain(:where, :order, :limit).and_return(@most_recent_updates)
        Answer.recent_updates.should == @most_recent_updates
      end
  end
end

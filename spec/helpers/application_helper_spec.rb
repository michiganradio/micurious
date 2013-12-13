=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe ApplicationHelper do
  describe "#badge_class" do
    context "when question is answered" do
      it "returns checkmark class" do
        question = Question.new(status: Question::Status::Answered)
        helper.badge_class(question).should == "checkmark"
      end
    end
    context "when question is investigating" do
      it "returns questionmark class" do
        question = Question.new(status: Question::Status::Investigating)
        helper.badge_class(question).should == "questionmark"
      end
    end

    context "when question is other" do
      it "return nil" do
        question = Question.new(status: Question::Status::New)
        helper.badge_class(question).should be_nil
      end
    end
  end

  describe "#question_image_url" do
    context "when question picture_url is present" do
      it "returns question picture_url" do
        question = Question.new(picture_url: "someurl")
        helper.question_image_url(question).should == question.picture_url
      end
    end

    context "when question picture_url is not present" do
      it "returns default picture" do
        question = Question.new(picture_url: "")
        helper.question_image_url(question).should == helper.image_url(DEFAULT_PICTURE)
      end
    end
  end

  describe "#question_display_text" do
    context "when display_text is over 140 characters" do
      it "cuts the text to 140 and appends ..." do
        question = Question.new(display_text: "a"*141)
        helper.question_display_text(question).should == "a"*140+"..."
      end
    end

    context "when display_text is under 140 characters" do
      it "keeps the text" do
        question = Question.new(display_text: "a"*140)
        helper.question_display_text(question).should == "a"*140
      end
    end
  end

  describe "#anonymity_partial" do
    context "when anonymous is false" do
      it "returns public partial" do
        question = Question.new(anonymous: false)
        helper.anonymity_partial(question).should == "confirm_public"
      end
    end
    context "when anonymous is true" do
      it "returns anonymous partial" do
        question = Question.new(anonymous: true)
        helper.anonymity_partial(question).should == "confirm_anonymous"
      end
    end
  end

  describe "#bigger_picture" do
    context "when picture_url is nil" do
      it "returns default picture" do
        question  = Question.new(picture_url: "")
        helper.bigger_picture(question).should == DEFAULT_PICTURE
      end
    end

    context "when picture_url is unsized" do
      it "returns bigger picture appended" do
        question  = Question.new(picture_url: "url.jpg")
        bigger_picture_question  = Question.new(picture_url: "url_b.jpg")
        helper.bigger_picture(question).should == bigger_picture_question.picture_url
        question.picture_url.should == "url.jpg"
      end
    end

    context "when picture_url is sized" do
      it "returns bigger picture appended" do
        question  = Question.new(picture_url: "url_s.jpg")
        bigger_picture_question  = Question.new(picture_url: "url_b.jpg")
        helper.bigger_picture(question).should == bigger_picture_question.picture_url
        question.picture_url.should == "url_s.jpg"
      end
    end
  end

  describe "#smaller_picture" do
    context "when picture_url is sized" do
      it "returns smaller picture appended" do
        question  = Question.new(picture_url: "url_b.jpg")
        helper.smaller_picture(question).should == "url_n.jpg"
      end
    end
  end
end

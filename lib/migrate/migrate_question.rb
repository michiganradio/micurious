=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'migrate/migrate'

class MigrateQuestion < Migrate
  def migrate_question(filepath = "./../ccdata.xls")
    s = Roo::Excel.new(filepath)
    question_sheet = s.sheet(0)
    spreadsheet_to_question_attributes = { "id"=>"id", "Question"=>"display_text", "Original Question"=>"original_text", "Neighborhood"=>"neighbourhood", "Name"=>"name", "Email"=>"email", "Image Attribution"=>"picture_attribution_url", "Image Username"=>"picture_owner", "Reporter"=>"reporter" }
    column_indices_names = spreadsheet_to_question_attributes.keys.push("Badge").push("Approved").push("Categories").push("Date Uploaded").push("Image Url").push("Response Link URL").push("Response Link Text").push("Timeline Key").push("Anonymous")

    column_indices = get_spreadsheet_column_indices(column_indices_names, question_sheet)
    questions = get_question_models(spreadsheet_to_question_attributes, question_sheet, column_indices)
    save_models(questions)
  end

  def get_question_models(spreadsheet_to_model_attribute_names, spreadsheet, attribute_column_indices)
    i=2
    questions = []

    while !spreadsheet.cell(i, 1).nil?
      question = Question.new
      map_generic_data(spreadsheet.row(i), question, spreadsheet_to_model_attribute_names, attribute_column_indices)
      map_question_data(spreadsheet.row(i), question, attribute_column_indices)
      questions.push question
      print "."
      # print "#{i-1} "
      i += 1
    end

    return questions
  end

  def map_question_data(row, question, attribute_column_indices)

    anonymous = row[attribute_column_indices["Anonymous"]]
    date_uploaded = row[attribute_column_indices["Date Uploaded"]]
    badge = row[attribute_column_indices["Badge"]]
    approved = row[attribute_column_indices["Approved"]]
    image_url = row[attribute_column_indices["Image Url"]]
    category_names = row[attribute_column_indices["Categories"]]
    response_link_text = row[attribute_column_indices["Response Link Text"]]
    response_link_url = row[attribute_column_indices["Response Link URL"]]
    timeline_key = row[attribute_column_indices["Timeline Key"]]

    question.email_confirmation = question.email
    question.anonymous = map_question_anonymous(anonymous)
    question.created_at = map_question_created_at(date_uploaded)
    question.status = map_question_status(badge, approved)
    question.picture_url = map_question_image_url(image_url)
    question.categories = map_question_categories(category_names)

    answer = map_question_answer(response_link_text, response_link_url, question.id)
    question.answers.push(answer) if answer

    timeline_update = map_question_timeline_update(timeline_key, question.id)
    question.answers.push(timeline_update) if timeline_update
  end

  def map_question_anonymous(anonymous)
    anonymous.to_i != 0
  end

  def map_question_created_at(date_uploaded)
    Time.at(date_uploaded.to_i)
  end

  def map_question_image_url(image_url)
    row_image_url = image_url
    image_url unless ( row_image_url == "images/default.jpg")
  end

  def map_question_status(badge, approved)
    if badge == "answered"
      Question::Status::Answered
    elsif badge == "investigated"
      Question::Status::Investigating
    elsif approved == 1
      Question::Status::New
    else
      Question::Status::Removed
    end
  end

  def map_question_categories(category_names_str)
    category_names_arr = category_names_str.to_s.rstrip.split(/, |,/)
    category_names_arr.map! { |name| name.downcase.gsub(/like to/, "like").gsub(/ /, '-') }
    categories = category_names_arr.map { |name| Category.where(name: name).first }
    categories
  end

  def map_question_answer(response_link_text, response_link_url, question_id)
    if response_link_text.presence
      answer = Answer.new
      answer.type = Answer::Type::Answer
      answer.label = response_link_text
      answer.url = response_link_url
      answer.question_id = question_id
      answer
    end
  end

  def map_question_timeline_update(timeline_key, question_id)
    if timeline_key.presence
      update = Answer.new
      update.type = Answer::Type::Update
      update.label = "Our reporting on this question"
      update.url = "http://cdn.knightlab.com/libs/timeline/latest/embed/index.html?source=#{timeline_key}&font=Bevan-PotanoSans"
      update.question_id = question_id
      update
    end
  end
end

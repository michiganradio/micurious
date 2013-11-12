require 'migrate/migrate'
class MigrateQuestion < Migrate
  def migrate_question(filepath = "./../ccdata.xls")
    s = Roo::Excel.new(filepath)
    question_sheet = s.sheet(0)
    spreadsheet_to_question_attributes = { "id"=>"id", "Question"=>"display_text", "Neighborhood"=>"neighbourhood", "Name"=>"name", "Email"=>"email", "Anonymous"=>"anonymous", "Image Url"=>"picture_url", "Image Attribution"=>"picture_attribution_url", "Image Username"=>"picture_owner", "Reporter"=>"reporter" }
    column_indices_names = spreadsheet_to_question_attributes.keys.push("Badge").push("Approved").push("Categories").push("Date Uploaded")

    column_indices = get_spreadsheet_column_indices(column_indices_names, question_sheet)
    models = get_question_models(spreadsheet_to_question_attributes, question_sheet, column_indices)
    save_models(models)
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
      i+=1
    end

    return questions
  end

  def map_question_data(row, question, attribute_column_indices)
    question.status = row[attribute_column_indices["Badge"]].presence || (row[attribute_column_indices["Approved"]]==1 ? "new" : "removed")
    question.email_confirmation = question.email
    question.anonymous = (row[attribute_column_indices["Anonymous"]].to_i != 0)
    question.created_at = Time.at(row[attribute_column_indices["Date Uploaded"]].to_i)
    map_question_categories(row, question, attribute_column_indices)
  end

  def map_question_categories(row, question, attribute_column_indices)
    category_names = row[attribute_column_indices["Categories"]].to_s.split(/, |,/)
    category_names.map! { |name| name.downcase.gsub(/like to/, "like").gsub(/ /, '-') }
    categories = category_names.map { |name| Category.where(name: name).first }
    question.categories = categories
  end
end


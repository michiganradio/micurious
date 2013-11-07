require 'roo'
def migrate_question(filepath = "./../ccdata.xls")
  s = Roo::Excel.new(filepath)
  question_sheet = s.sheet(0)
  spreadsheet_to_question_attributes = { "id"=>"id", "Question"=>"display_text", "Date Uploaded"=>"created_at", "Neighborhood"=>"neighbourhood", "Name"=>"name", "Email"=>"email", "Anonymous"=>"anonymous", "Image Url"=>"picture_url", "Image Attribution"=>"picture_attribution_url", "Image Username"=>"picture_owner", "Reporter"=>"reporter" }
  column_indices_names = spreadsheet_to_question_attributes.keys.push("Badge").push("Approved")

  column_indices = get_spreadsheet_column_indices(column_indices_names, question_sheet)
  models = get_question_models(spreadsheet_to_question_attributes, question_sheet, column_indices)
  save_models(models)
end

def get_spreadsheet_column_indices(column_names, sheet)
  question_sheet_attributes = sheet.row(1)
  attribute_to_column = {}
  column_names.each do |name|
    attribute_to_column[name] = question_sheet_attributes.find_index(name)
  end
  return attribute_to_column
end

def get_question_models(spreadsheet_to_model_attribute_names, spreadsheet, attribute_column_indices)
  i=2
  questions = []
  while !spreadsheet.cell(i, 1).nil?
    question = Question.new
    map_generic_data(spreadsheet.row(i), question, spreadsheet_to_model_attribute_names, attribute_column_indices)
    map_question_data(spreadsheet.row(i), question, attribute_column_indices)
    questions.push question
    i+=1
  end
  return questions
end

def map_generic_data(row, model, spreadsheet_to_model_attribute_names, attribute_column_indices)
  for column_name in spreadsheet_to_model_attribute_names.keys do
    model.send("#{spreadsheet_to_model_attribute_names[column_name]}=", row[attribute_column_indices[column_name]])
  end
end

def map_question_data(row, question, attribute_column_indices)
  question.status = row[attribute_column_indices["Badge"]].presence || (row[attribute_column_indices["Approved"]]==1 ? "new" : "removed")
  question.email_confirmation = question.email
end

def save_models(models)
  models.each { |model|  model.valid? ? model.save : (p model.errors) }
end
#migrate_question("./../ccdata.xls")

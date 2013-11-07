require 'roo'
def migrate_question(filepath = "./../ccdata.xls")
  s = Roo::Excel.new(filepath)
  question_sheet = s.sheet(0)
  spreadsheet_to_question_attributes = { "id"=>"id", "Name"=>"name", "Question"=>"display_text", "Anonymous"=>"anonymous"}

  column_indices = get_spreadsheet_column_indices(spreadsheet_to_question_attributes.keys, question_sheet)
  models = get_spreadsheet_models(Question, spreadsheet_to_question_attributes, question_sheet, column_indices)
  save_models(models)
end

def get_spreadsheet_column_indices(column_names, sheet)
  question_sheet_attributes = sheet.row(1)
  attribute_to_column = {}
  column_names.each do |name|
    attribute_to_column[name] = question_sheet_attributes.find_index(name)+1
  end
  return attribute_to_column
end

def get_spreadsheet_models(model_class, spreadsheet_to_model_attribute_names, spreadsheet, attribute_column_indices)
  i=2
  models = []
  while !spreadsheet.cell(i, 1).nil?
    new_model = model_class.new
    propagate_spreadsheet_data_to_model(spreadsheet, new_model, i, spreadsheet_to_model_attribute_names, attribute_column_indices)
    models.push new_model
    i+=1
  end
  return models
end

def propagate_spreadsheet_data_to_model(spreadsheet, model, model_index, spreadsheet_to_model_attribute_names, attribute_column_indices)
  for column_name in spreadsheet_to_model_attribute_names.keys do
    p "attribute setting:" + spreadsheet_to_model_attribute_names[column_name]
    p spreadsheet.cell(model_index, attribute_column_indices[column_name])
    model.send("#{spreadsheet_to_model_attribute_names[column_name]}=", spreadsheet.cell(model_index, attribute_column_indices[column_name]))
  end
end

def save_models(models)
  models.each { |model| model.save }
end

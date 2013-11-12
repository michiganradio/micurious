require 'roo'

class Migrate
  def get_spreadsheet_column_indices(column_names, sheet)
    question_sheet_attributes = sheet.row(1)
    attribute_to_column = {}
    column_names.each do |name|
      attribute_to_column[name] = question_sheet_attributes.find_index(name)
    end
    return attribute_to_column
  end

  def map_generic_data(row, model, spreadsheet_to_model_attribute_names, attribute_column_indices)
    for column_name in spreadsheet_to_model_attribute_names.keys do
      model.send("#{spreadsheet_to_model_attribute_names[column_name]}=", row[attribute_column_indices[column_name]])
    end
  end

  def save_models(models)
    models.each { |model|  model.valid? ? model.save : (p model.errors) }
  end
end


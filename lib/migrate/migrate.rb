=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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
    models.each do |model|
      model.valid? ? model.save : (model.errors.each{ |attribute, error| p "#{model.id}|#{attribute}|#{model.send(attribute)}|#{error}."} )
    end
  end
end


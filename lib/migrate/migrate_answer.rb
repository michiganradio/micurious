require 'migrate/migrate'
class MigrateAnswer < Migrate
  def migrate_answer(filepath = "./../ccdata.xls")
    s = Roo::Excel.new(filepath)
    sheet = s.sheet(0)
    spreadsheet_to_answer_attributes = { "id"=>"question_id", "Response Link URL"=>"url", "Response Link Text"=>"label" }

    column_indices = get_spreadsheet_column_indices(spreadsheet_to_answer_attributes.keys, sheet)
    models = get_answer_models(spreadsheet_to_answer_attributes, sheet, column_indices)
    save_models(models)
    return models
  end

  def get_answer_models(spreadsheet_to_model_attribute_names, spreadsheet, column_indices)
    i=2
    answers = []
    while !spreadsheet.cell(i, 1).nil?
      answer = Answer.new
      map_generic_data(spreadsheet.row(i), answer, spreadsheet_to_model_attribute_names, column_indices)
      map_answer_data(answer)
      answers.push answer unless answer.label.nil?
      i+=1
    end
    return answers
  end

  def map_answer_data(answer)
    answer.type = Answer::Type::Answer
  end
end
#m = MigrateAnswer.new
#m.migrate_answer("./../ccdata.xls")

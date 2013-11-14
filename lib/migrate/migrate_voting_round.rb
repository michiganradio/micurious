require 'migrate/migrate'

class MigrateVotingRound < Migrate
  def migrate_voting_round(filepath="./../ccdata.xls")
    excel_file = Roo::Excel.new(filepath)
    voting_rounds = get_voting_round_models(excel_file)
    save_models(voting_rounds)
  end

  def get_voting_round_models(excel_file)
    spreadsheet_to_voting_round_question_attributes = { "Id"=>"question_id",
                                                        "Votes"=>"vote_number" }
    column_indices_names = spreadsheet_to_voting_round_question_attributes.keys
    column_indices = get_spreadsheet_column_indices(column_indices_names, excel_file.sheet(1))
    voting_rounds = []

    excel_file.sheets[1..-1].reverse.each_with_index do |sheet_name, index|
      voting_rounds.push(get_voting_round_model(spreadsheet_to_voting_round_question_attributes, sheet_name, excel_file.sheet(excel_file.sheets.size - (index+1)), column_indices))
      print "."
    end

    voting_rounds.last.status = VotingRound::Status::Live
    return voting_rounds
  end

  def get_voting_round_model(spreadsheet_to_voting_round_question_attributes, sheet_name, sheet, column_indices)
    voting_round = VotingRound.new
    voting_round.start_time = map_voting_round_start_time(sheet_name)
    voting_round.end_time = map_voting_round_end_time(sheet_name)
    voting_round.created_at = voting_round.start_time
    voting_round.status = VotingRound::Status::Completed
    voting_round.voting_round_questions = map_voting_round_questions(spreadsheet_to_voting_round_question_attributes, sheet, column_indices)
    voting_round
  end

  def set_voting_round_times(voting_round, label)
  end

  def map_voting_round_start_time(label)
    dates = label.split(" - ")
    year = dates[1].split(",").last
    start_date = dates[0] + year
    DateTime.parse(start_date)
  end

  def map_voting_round_end_time(label)
    dates = label.split(" - ")
    DateTime.parse(dates[1])
  end

  def map_voting_round_questions(spreadsheet_to_voting_round_question_attributes, spreadsheet, column_indices)
    i = 2
    voting_round_questions = []

    while !spreadsheet.cell(i, 1).nil?
      voting_round_question = VotingRoundQuestion.new
      map_generic_data(spreadsheet.row(i), voting_round_question, spreadsheet_to_voting_round_question_attributes, column_indices)
      voting_round_questions.push(voting_round_question)
      i += 1
    end

    voting_round_questions
  end
end

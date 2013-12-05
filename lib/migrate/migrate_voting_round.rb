=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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
    voting_round.public_label = sheet_name
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

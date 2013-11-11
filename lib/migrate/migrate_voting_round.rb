class MigrateVotingRound < Migrate
  def migrate_voting_round(filepath="./../ccdata.xls")
    s = Roo::Excel.new(filepath)
    tabs = s.sheets
    voting_rounds = get_voting_round_models(tabs)
    save_models(voting_rounds)
  end

  def get_voting_round_models(vr_names)
    voting_rounds = []
    vr_names[1..-1].each do |name, index|
      voting_round = VotingRound.new
      voting_round.label = name
      set_voting_round_dates(voting_round, label)
      voting_round.questions = get_voting_round_questions(s.sheet(index+1))
      voting_rounds.push voting_round
    end
    return voting_rounds
  end
   def set_voting_round_dates(voting_round, label)
   end
end

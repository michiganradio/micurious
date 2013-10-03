json.array!(@voting_round_questions) do |voting_round_question|
  json.extract! voting_round_question, :voting_round_id, :question_id, :vote_number
  json.url voting_round_question_url(voting_round_question, format: :json)
end

json.array!(@voting_rounds) do |voting_round|
  json.extract! voting_round, :start_time, :end_time
  json.url voting_round_url(voting_round, format: :json)
end

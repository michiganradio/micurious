json.array!(@questions) do |question|
  json.extract! question, :original_text, :display_text
  json.url question_url(question, format: :json)
end

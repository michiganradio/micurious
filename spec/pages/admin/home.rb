class Admin::Home < SitePrism::Page
  set_url "/admin"

  element :categories_dropdown, "#category"
  element :search_text_field, "#text"
  element :search_button, "#search-button"
  elements :search_question, ".search-question"
  elements :current_voting_round_questions, ".voting-round-question"
  elements :recent_questions, ".recent-question"
  elements :recent_answers, ".recent-answer"
  elements :recent_updates, ".recent-update"
  elements :recent_notes, ".recent-note"
  elements :recent_tags, ".recent-tag"
end

class Admin::EditQuestion < SitePrism::Page
  set_url "/admin/questions{/id}/edit"

  element :add_question_to_voting_round_button, "input[value='Add question to voting round']"
  element :add_question_to_voting_round_error, ".alert-error"
  element :add_question_to_voting_round_confirmation, ".alert-notice"
  element :label_dropdown, "select[id='voting_round_id']"
  element :picture_url, "#question_picture_url"
  element :picture_owner, "#question_picture_owner"
  element :picture_attribution_url, "#question_picture_attribution_url"
  element :reporter, "#question_reporter"
  element :update_question_button, "input[value='Update Question']"
  element :new_answer_button, "#add-answer-button"
  element :status_dropdown, "#question_status"
  element :featured, "#question_featured"
end

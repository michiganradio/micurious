class Admin::EditQuestion < SitePrism::Page
  set_url "/admin/questions{/id}/edit"

  element :add_question_to_voting_round_button, "input[value='Add question to voting round']"
  element :add_question_to_voting_round_error, ".alert-error"
  element :add_question_to_voting_round_confirmation, ".alert-notice"
  element :label_dropdown, "select[id='voting_round_id']"
end

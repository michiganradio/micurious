require 'modal_section'

class AskQuestionSection < ModalSection
  element :question_display_text, "#question_display_text"
  element :question_name, "#question_name"
  element :question_anonymous, "#question_anonymous"
  element :question_email, "#question_email"
  element :question_email_confirmation, "#question_email_confirmation"
  element :question_neighbourhood, "#question_neighbourhood"
  elements :question_categories, ".categories-group .checkbox-group input"
  element :modal_form_next, "#modal-form-next"
end

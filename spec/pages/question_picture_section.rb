require 'modal_section'

class QuestionPictureSection < ModalSection
  element :search_button, '#search-flicker'
  element :submit_button, '#modal-form-submit'
  element :modal_form_back, "#modal-form-back"
  element :search_field, '#search-field'
  element :pictures, '#pictures'
  elements :thumbnails, 'span'
end

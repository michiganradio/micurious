require 'modal_section'

class QuestionPictureSection < ModalSection
  element :search_button, '#search-flickr'
  element :next_button, '#modal-form-next'
  element :modal_form_back, "#modal-form-back"
  element :search_field, '#search-field'
  element :pictures, '#pictures'
  elements :thumbnails, '.thumbnail'
end

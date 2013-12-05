=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'modal_section'

class AskQuestionSection < ModalSection
  element :question_display_text, "#question_display_text"
  element :question_description, "#question_description"
  element :question_name, "#question_name"
  element :question_anonymous, "#question_anonymous"
  element :question_email, "#question_email"
  element :question_email_confirmation, "#question_email_confirmation"
  element :question_neighbourhood, "#question_neighbourhood"
  elements :question_categories, ".categories-group .checkbox-group input"
  element :modal_form_next, "#modal-form-next"
  element :modal_form_back, "#modal-form-back"
  element :question_guideline_link, "#question-guideline-link"
  element :popup, ".popover"
end

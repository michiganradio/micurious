=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::NewAnswer < SitePrism::Page
  set_url "/admin/answers/new{?question_id*}"
  set_url_matcher /\/admin\/answers\/new/

  element :answer_url_field, "#answer_url"
  element :answer_label_field, "#answer_label"
  element :add_answer_button, "input[value='Add answer to question']"
  element :answer_type_answer_radio_button, "input#answer_type_answer"
  element :answer_type_update_radio_button, "input#answer_type_update"
  elements :add_answer_to_question_errors, ".error-message"
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::EditQuestion < SitePrism::Page
  set_url "/admin/questions{/id}/edit"

  element :add_question_to_voting_round_button, "input[value='Add question to voting round']"
  element :add_question_to_voting_round_error, ".alert-error"
  element :add_question_to_voting_round_confirmation, ".alert-notice"
  element :private_label_dropdown, "select[id='voting_round_id']"
  element :picture_url, "#question_picture_url"
  element :picture_owner, "#question_picture_owner"
  element :picture_attribution_url, "#question_picture_attribution_url"
  element :reporter, "#question_reporter"
  element :update_question_button, "input[value='Update Question']"
  element :new_answer_button, "#add-answer-button"
  element :status_dropdown, "#question_status"
  element :featured, "#question_featured"
  element :notes, "#question_notes"
  element :tags, "#question_tag_list"
end

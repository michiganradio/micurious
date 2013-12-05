=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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

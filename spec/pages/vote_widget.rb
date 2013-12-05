=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class VoteWidget < SitePrism::Page
  set_url "/vote_widget"
  set_url_matcher /\/vote_widget/
  elements :questions, "div .widget-question"
  element :widget_prompt, ".widget-prompt"
  elements :vote_buttons, "a.vote"

  def has_number_of_questions? size_to_expect
    questions.size == size_to_expect
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class SubmitMobile < SitePrism::Page
  set_url  "/submit_mobile"
  set_url_matcher /\/submit_mobile/

  element :vote_link, "#vote-link"
  element :browse_answers_link, "#browse-answers-link"
  element :browse_questions_link, "#browse-questions-link"

end

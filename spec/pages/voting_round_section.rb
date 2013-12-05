=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class VotingRoundSection < SitePrism::Section
  elements :vote_links, ".vote:not(.visible-xs)"
  elements :question_links, "div.question-text > a.question-link"
  elements :picture_links, "span.image-credits > a"
  elements :pictures, "div.question-image img"
  elements :ranks, "h2.rank"
  element :vote_confirm, "div.voted:not(.visible-xs)"
end

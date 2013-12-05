=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::VotingRounds < SitePrism::Page
  set_url "/admin/voting_rounds/"
  element :new_voting_round_button, "#new-voting-round-btn"
  elements :rows, "tr[id] > .public-label-display"

  def has_public_label? matching_exp
    match_arr = rows.map { |row| row.text =~ matching_exp }
    match_arr.any?
  end
end

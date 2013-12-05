=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::EditVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}/edit"
  element :public_label, "#voting_round_public_label"
  element :update_button, "input[value='Update Voting round']"
  element :status_dropdown, "select[id='voting_round_status']"
end

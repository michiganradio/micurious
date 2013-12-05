=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class Admin::ShowQuestion < SitePrism::Page
  set_url "/admin/questions/{/id}"
  set_url_matcher /\/admin\/questions\/\d+/
  element :reporter, ".reporter"
  element :status, ".status"
  elements :answer_urls, ".answer_url"
  elements :answer_labels, ".answer_label"
  elements :update_urls, ".update_url"
  elements :update_labels, ".update_label"
end

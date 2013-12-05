=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class MakeLabelAndUrlAndQuestionIdNotNullInResponses < ActiveRecord::Migration
  def change
    change_column :responses, :label, :string, :null => false
    change_column :responses, :url, :string, :null => false
    change_column :responses, :question_id, :integer, :null => false
    change_column :responses, :type, :string, :null => false
  end
end

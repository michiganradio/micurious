=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class AddResponsesTable < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :label, nullable: false
      t.string :url, nullable: false
      t.references :question, index: true, nullable: false
      t.string :type, nullable: false

      t.timestamps
    end
  end
end

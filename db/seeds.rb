=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#


Category.create([{ name: 'how-we-live', label: 'How we live', active: true},
                 { name: 'history', label: 'History', active: true},
                 { name: 'environment', label: 'Environment', active: true},
                 { name: 'economy', label: 'Economy', active: true},
                 { name: 'governance', label: 'Governance', active: true},
                 { name: 'urban-planning', label: 'Urban Planning', active: true},
                 { name: 'whats-it-like', label: 'What\'s it like to...', active: true}])

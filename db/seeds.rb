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

require 'roo'
s = Roo::Excel.new("./../ccdata.xls")
s.default_sheet = s.sheets.first
question_sheet = s.sheet(0)
(1..1000).each do |i|
p question_sheet.row(i)
end

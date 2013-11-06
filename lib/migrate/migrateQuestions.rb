require 'CSV'
class MigrateQuestions
  def generate_CSV_table(csv_file)
    CSV.table(csv_file, headers: true)
  end

  def take_question_data(csv_table)
    question_attributes = [ "id", "display_text", "created_at", "updated_at", "active", "neighbourhood", "name", "email", "anonymous", "picture_url", "picture_owner", "picture_attributions_url", "reporter" ]
    csv_table.by_col!
    csv_table.delete_if { |column_name, column| question_attributes.include? column_name }
  end

  def generate_question_csv(csv_table)
    File.open("lib/migrate/question.csv", 'w') { |file| file.write(csv_table.to_csv) }
  end

  def generate_question_sql
    File.open("lib/migrate/question.sql", 'w') { |file| file.write( "LOAD DATA INFILE './questions.csv' INTO TABLE questions FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';") }
  end
end

# table =  MigrateQuestions.new.generate_CSV_table(ARGV[0])
# p table
# p MigrateQuestions.new.take_question_data(table)

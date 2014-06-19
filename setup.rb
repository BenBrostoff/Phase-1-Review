require 'sqlite3'
require 'csv'
require_relative 'adrian_solution.rb'


$db = SQLite3::Database.new "student_data.db"
$db.execute(
      <<-SQL
        CREATE TABLE students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR(64),
          last_name VARCHAR(64),
          email VARCHAR(64),
          phone VARCHAR(64),
          grade VARCHAR(64),
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    )

parser = StudentParser.new
parser.import_csv('students.csv')
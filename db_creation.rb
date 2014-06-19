require 'CSV'
require 'sqlite3'

module CSVParser

  def self.parse(file)
    array = CSV.read(file)
    array.delete_at(0)
    return array
  end

end


module SQLBuild

  include CSVParser

  def self.schema(database)
    schema = "CREATE TABLE IF NOT EXISTS students (
              id INTEGER PRIMARY KEY ASC,
              first_name CHAR(100),
              last_name CHAR(100),
              email CHAR(100),
              phone CHAR(100),
              grade INTEGER
              );"
    database.execute("#{schema}")
  end
    
  def self.populate(file, database, table_name)
    array_format = CSVParser.parse(file) 
    array_format.each do |row|
      row.delete_at(0)
      database.execute("INSERT INTO #{table_name} (first_name, last_name, email, phone, grade) values (?,?,?,?,?)", row)
    end
  end


end

db = SQLite3::Database.new "students.db", results_as_hash: true

SQLBuild.schema(db)
SQLBuild.populate('students.csv', db, 'students')




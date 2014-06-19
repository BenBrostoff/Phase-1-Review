require 'csv'
require 'sqlite3'

# Steps
# Pull in CSV data ==> Database
# Create class for Students with Create, Read, Update, Delete methods
# Create StudentParser class that executes the import from CSV to DB methods

class Student 
	include StudentParser 

	def initialize(args)
		@id = args[:id]
		@first_name = args[:first_name] 
		@last_name = args[:last_name] 
		@email = args[:email] 
		@phone = args[:phone] 
		@grade = args[:grade] 
	end

	def save
		$db.execute("INSERT INTO students (first_name, last_name, email, phone, grade, created_at, updated_at) 
								 VALUES (?,?,?,?,?,DATETIME('now'), DATETIME('now'))", @first_name, @last_name, @email, @phone, @grade)
		@id = $db.execute("SELECT last_insert_rowid()")
	end

	def delete

	end

	def all

	end

	def include?


	end

end


module StudentParser

	def import_csv(file)
		CSV.foreach(file, headers: true) do |row|
			$db.execute("INSERT INTO students (first_name, last_name, email, phone, grade, created_at, updated_at) 
									VALUES (?,?,?,?,?, DATETIME('now'), DATETIME('now'))", row[1], row[2], row[3], row[4], row[5])
		end
	end

end
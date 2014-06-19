require 'csv'
require 'sqlite3'


$db = SQLite3::Database.new "student_data.db"

class Student 
	attr_accessor :id, :first_name, :last_name, :email, :phone, :grade

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
								 VALUES (?,?,?,?,?, DATETIME('now'), DATETIME('now'))", @first_name, @last_name, @email, @phone, @grade)
		@id = $db.execute("SELECT last_insert_rowid()")
	end

	def delete
		$db.execute("DELETE FROM students WHERE id = ?", @id)
	end

	def all
	end

	def update(field, value)
		$db.execute("UPDATE students SET #{field} = ? WHERE id = ?",[value, @id])
	end

end

class StudentParser

	def import_csv(file)
		CSV.foreach(file, headers: true) do |row|
			$db.execute("INSERT INTO students (first_name, last_name, email, phone, grade, created_at, updated_at) 
									VALUES (?,?,?,?,?, DATETIME('now'), DATETIME('now'))", row[1], row[2], row[3], row[4], row[5])
		end
	end

end

adrian = Student.new(:first_name => "Adrian", :last_name => "Soghoian", :email => "adriansoghoian@gmail.com", :phone => "asdfwef", :grade => "100")
adrian.save
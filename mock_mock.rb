require 'csv'
require 'SQLite3'

$db = SQLite3::Database.new "school_database.db"

$db.execute(
      <<-SQL
        CREATE TABLE school_database (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR(64) NOT NULL,
          last_name VARCHAR(64) NOT NULL,
          email VARCHAR(64) NOT NULL,
          phone VARCHAR(64) NOT NULL,
          grade VARCHAR(64) NOT NULL,
          cohort VARCHAR(64) NOT NULL,
          created_at DATETIME NOT NULL,
          updated_at DATETIME NOT NULL
        );
      SQL
      )


#FROM CSV TO SQL

CSV.foreach(filename, 'wb') do |row|
	$db.execute("INSERT INTO school_database (id,first_name, last_name, email, phone, grade, cohort)
							VALUES (?, ?, ?, ?, ?, ?, ?", row[0], row[1], row[2], row[3], row[4], row[5], row[6])
						end

class Student
	attr_accessor :id, :first_name, :last_name, :email, :phone, :grade, :cohort
	def initialize( args = {} )
		@id = args.fetch(:id)																								
		@first_name = args.fetch(:first_name)
		@last_name = args.fetch(:last_name)
		@email = args.fetch(:email)
		@phone = args.fetch(:phone)
		@grade = args.fetch(:grade)
		@cohort = args.fetch(:cohort, nil)
	end

	
	def save_student
		$db.execute("INSERT INTO school_database (id,first_name, last_name, email, phone, grade, cohort, created_at, updated_at)
								VALUES(?, ?, ?, ?, ?, ?, DATETIME('now), DATETIME('now)",@first_name, @last_name, @email, @phone, @grade, @cohort)
	end

	def update(field, value)
		 $db.execute("UPDATE students SET #{field} = ? WHERE id = ?",[value, @id])
	end

	def count
		$db.execute("SELECT COUNT(*) FROM school_database")
	end

	def find(first_name, last_name)
		$db.execute(SELECT * FROM school_database WHERE first_name="#{first_name}" AND last_name="#{last_name}")
	end

end


class School
	attr_accessor :student_list

	def initialize()
		@student_list = []
	end

	def add_student(student)
		@student_list << student
	end

	def self.save_to_csv(filename, student_list)
		CSV.open(filename, 'wb') do |csv|
			csv << %w[id, first_name, last_name, email, phone, grade, cohort]

			student_list.each do |student|
				csv << student
			end
		end
	end
end



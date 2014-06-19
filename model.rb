require 'sqlite3'

module StudentDatabase

  def self.db
    db = SQLite3::Database.new "students.db", results_as_hash: true
  end

end

class Student
  include StudentDatabase

  @@students = []

  attr_accessor :id, :first_name, :last_name, :email, :phone, :grade

  def initialize(params = {})
    @id = params["id"] #need to get to symbols ideally
    @first_name = params["first_name"]
    @last_name = params["last_name"]
    @email = params["email"]
    @phone = params["phone"]
    @grade = params["grade"]
  end

  def save

  end

  def self.where(category, value)
    student_holder = []
    results = StudentDatabase.db.execute("SELECT * from students WHERE #{category}", value)
    results.each do |result|
      student_holder << Student.new(result) 
    end
    student_holder
  end

  def all
    @@students
  end

end

p Student.where("id > ?", 25)


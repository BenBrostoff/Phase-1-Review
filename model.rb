require 'sqlite3'

module StudentDatabase

  def self.db
    db = SQLite3::Database.new "students.db", results_as_hash: true
  end

end

class Student
  include StudentDatabase

  @@students = []
  @@id_track = StudentDatabase.db.execute("SELECT max(id) from students")[0].values[0]

  attr_accessor :id, :first_name, :last_name, :email, :phone, :grade

  def initialize(params = {})
    @id = params["id"] #need to get to symbols ideally
    @first_name = params["first_name"] ||= "John"
    @last_name = params["last_name"] ||= "Connor"
    @email = params["email"] ||= "terminate@terminate.com"
    @phone = params["phone"] ||= "123-546-789"
    @grade = params["grade"] ||= "12"
  end

  def self.id_track
    @@id_track
  end

  def save #is there a quicker way on first conditional?
    if self.id <= @@id_track
      StudentDatabase.db.execute("UPDATE students SET first_name = #{self.first_name} WHERE id = ?", self.id)
    else
      @@students << self
      StudentDatabase.db.execute("INSERT INTO students VALUES (?,?,?,?,?,?)", self.all_attributes)
    end

  end

  def all_attributes
    all = [self.id, self.first_name, self.last_name, self.email, self.phone, self.grade]
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

# p Student.where("id > ?", 25)
p Student.id_track
john = Student.new ({"id" => 29})
p john
john.save

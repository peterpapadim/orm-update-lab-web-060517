require 'pry'
require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    query = ("CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT)
    ")
    DB[:conn].execute(query)
  end

  def self.drop_table
      query = ("DROP TABLE students")
      DB[:conn].execute(query)
  end

  def save
    if self.id
      self.update
    else
      query = ("INSERT INTO students (name, grade) VALUES (?, ?)")
      DB[:conn].execute(query, self.name, self.grade)
      id_query = ("SELECT last_insert_rowid() FROM students")
      @id = DB[:conn].execute(id_query)[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    student = self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    query = ("SELECT * FROM students WHERE name = ?")
    result = DB[:conn].execute(query, name)
    self.new_from_db(result.first)
  end

  def update
    query = ("UPDATE students SET id = ?, name = ?, grade = ?")
    DB[:conn].execute(query, self.id, self.name, self.grade)
  end

end

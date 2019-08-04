module Relations
  class Courses < ROM::Relation[:sql]
    schema(:courses, infer: true) do
      associations do
        has_many :courses_employees
        has_many :employees, as: :instructors, through: :courses_employees

        has_many :courses_students
        has_many :students, through: :courses_students
      end
    end
  end
end

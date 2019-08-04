module Relations
  class CoursesStudents < ROM::Relation[:sql]
    schema(:courses_students, infer: true) do
      associations do
        belongs_to :course
        belongs_to :student
      end
    end
  end
end

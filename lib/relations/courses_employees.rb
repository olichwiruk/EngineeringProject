module Relations
  class CoursesEmployees < ROM::Relation[:sql]
    schema(:courses_employees, infer: true) do
      associations do
        belongs_to :course
        belongs_to :employee
      end
    end
  end
end

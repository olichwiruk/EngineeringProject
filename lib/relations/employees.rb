module Relations
  class Employees < ROM::Relation[:sql]
    schema(:employees, infer: true) do
      associations do
        has_many :courses_employees
        has_many :courses, through: :courses_employees
      end
    end
  end
end

module Relations
  class Students < ROM::Relation[:sql]
    schema(:students, infer: true) do
      associations do
        has_many :courses_students
        has_many :courses, through: :courses_students
      end
    end
  end
end

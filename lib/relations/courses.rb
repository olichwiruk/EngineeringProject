module Relations
  class Courses < ROM::Relation[:sql]
    schema(:courses, infer: true)
  end
end

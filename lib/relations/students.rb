module Relations
  class Students < ROM::Relation[:sql]
    schema(:students, infer: true)
  end
end

module Repositories
  class StudentRepo < ROM::Repository[:students]
    auto_struct false

    def by_index_number(index_number)
      students
        .where(index_number: index_number)
        .map_to(::Entities::Student)
        .one
    end
  end
end

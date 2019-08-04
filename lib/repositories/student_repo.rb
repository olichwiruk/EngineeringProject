module Repositories
  class StudentRepo < ROM::Repository[:students]
    auto_struct false

    def by_index_number(index_number)
      students
        .where(index_number: index_number)
        .map_to(::Entities::Student)
        .one
    end

    def save(entity)
      return if index_numbers.include? entity.index_number
      students.changeset(:create, entity).commit
    end

    private def index_numbers
      @index_numbers ||= students.pluck(:index_number)
    end
  end
end

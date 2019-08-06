module Repositories
  class StudentRepo < ROM::Repository[:students]
    auto_struct false

    def by_index_numbers(index_numbers)
      students
        .where(index_number: index_numbers)
        .map_to(::Entities::Student)
        .to_a
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

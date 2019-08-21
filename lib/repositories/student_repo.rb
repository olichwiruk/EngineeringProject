module Repositories
  class StudentRepo < ROM::Repository[:students]
    auto_struct false

    def by_index_numbers(index_numbers)
      students
        .where(index_number: index_numbers)
        .map_to(::Entities::Student)
        .to_a
    end

    def save_many(entities)
      entities_to_create = entities.dup.delete_if do |student|
        index_numbers.include?(student.index_number)
      end

      students.changeset(:create, entities_to_create).commit
      by_index_numbers(entities.map(&:index_number))
    end

    private def index_numbers
      @index_numbers ||= students.pluck(:index_number)
    end
  end
end

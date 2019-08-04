module Repositories
  class CourseRepo < ROM::Repository[:courses]
    auto_struct false

    def by_id(id)
      graph
        .where(id: id)
        .map_to(::Entities::Course)
        .one
    end

    def by_group(group)
      graph
        .where(group: group)
        .map_to(::Entities::Course)
        .one
    end

    def save(entity)
      create(entity) unless by_group(entity.group)
      by_group(entity.group)
    end

    private def create(entity)
      courses.transaction do
        course = ::Entities::Course.new(
          courses.changeset(:create, entity).commit
        )

        students
          .changeset(:create, entity.students)
          .associate(course, :courses)
          .commit
        employees
          .changeset(:create, entity.instructors)
          .associate(course, :courses)
          .commit
      end
    end

    private def graph
      courses.combine(:employees, :students)
    end
  end
end

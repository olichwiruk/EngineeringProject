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
      if by_group(entity.group)
        update(entity)
      else
        create(entity)
      end

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

    private def update(entity)
      courses.transaction do
        courses_employees
          .where(course_id: entity.id)
          .changeset(:delete)
          .commit

        courses_employees
          .changeset(
            :create,
            entity.instructors.map do |instructor|
              {
                course_id: entity.id,
                employee_id: instructor.id
              }
            end
          ).commit
      end
    end

    private def graph
      courses.combine(:employees, :students)
    end
  end
end

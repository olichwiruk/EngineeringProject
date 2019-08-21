module Repositories
  class CourseRepo < ROM::Repository[:courses]
    auto_struct false

    def by_id(id)
      graph
        .where(id: id)
        .map_to(::Entities::Course)
        .one
    end

    def find(entity)
      graph
        .where(
          group: entity.group,
          academic_year: entity.academic_year
        )
        .map_to(::Entities::Course)
        .one
    end

    def all
      courses
        .map_to(::Entities::Course)
        .to_a
    end

    def save(entity)
      if find(entity)
        update(entity)
      else
        create(entity)
      end

      find(entity)
    end

    private def create(entity)
      courses.transaction do
        course = ::Entities::Course.new(
          courses.changeset(:create, entity).commit
        )

        courses_students
          .changeset(
            :create,
            entity.students.map do |student|
              {
                course_id: course.id,
                student_id: student.id
              }
            end
          ).commit

        courses_employees
          .changeset(
            :create,
            entity.instructors.map do |instructor|
              {
                course_id: course.id,
                employee_id: instructor.id
              }
            end
          ).commit
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

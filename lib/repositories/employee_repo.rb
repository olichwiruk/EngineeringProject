module Repositories
  class EmployeeRepo < ROM::Repository[:employees]
    auto_struct false

    def by_id(id)
      employees
        .where(id: id)
        .map_to(::Entities::Employee)
        .one
    end

    def by_ids(ids)
      employees
        .where(id: ids)
        .map_to(::Entities::Employee)
        .to_a
    end

    def find(entity)
      employees
        .where(
          title: entity.title,
          name: entity.name,
          surname: entity.surname
        )
        .map_to(::Entities::Employee)
        .one
    end

    def without_instuctors_of(course)
      employees
        .exclude(
          id: courses_employees
                .where(course_id: course.id)
                .pluck(:employee_id)
          )
        .map_to(::Entities::Employee)
        .to_a
    end

    def save(entity)
      return unless entity.valid?
      return find(entity) if find(entity)

      ::Entities::Employee.new(
        employees.changeset(:create, entity).commit
      )
    end
  end
end

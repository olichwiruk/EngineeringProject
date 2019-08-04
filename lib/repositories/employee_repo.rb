module Repositories
  class EmployeeRepo < ROM::Repository[:employees]
    auto_struct false

    def by_id(id)
      employees
        .where(id: id)
        .map_to(::Entities::Employee)
        .one
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

    def save(entity)
      return if find(entity)
      employees.changeset(:create, entity).commit
    end
  end
end

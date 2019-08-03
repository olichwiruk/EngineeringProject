module Repositories
  class EmployeeRepo < ROM::Repository[:employees]
    auto_struct false

    def by_id(id)
      employees
        .where(id: id)
        .map_to(::Entities::Employee)
        .one
    end
  end
end

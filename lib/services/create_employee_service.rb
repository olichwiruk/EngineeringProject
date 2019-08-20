module Services
  class CreateEmployeeService
    attr_reader :employee_repo

    def initialize(employee_repo)
      @employee_repo = employee_repo
    end

    def call(title, name, surname)
      employee_repo.save(
        ::Entities::Employee.new(
          title: title,
          name: name,
          surname: surname
        )
      )
    end
  end
end

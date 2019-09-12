module Services
  class GenerateDeleteScriptService
    attr_reader :employee_repo, :student_repo,
      :remove_employees_script_generator,
      :remove_students_script_generator,
      :delete_databases_script_generator

    def initialize(
      employee_repo,
      student_repo,
      remove_employees_script_generator,
      remove_students_script_generator,
      delete_databases_script_generator
    )
      @employee_repo = employee_repo
      @student_repo = student_repo
      @remove_employees_script_generator = remove_employees_script_generator
      @remove_students_script_generator = remove_students_script_generator
      @delete_databases_script_generator = delete_databases_script_generator
    end

    def call(
      employee_ids_to_delete_account:,
      index_numbers_to_delete_account:,
      index_numbers_to_delete_database:
    )
      script = ''

      if employee_ids_to_delete_account &&
          !employee_ids_to_delete_account.empty?
        employees = employee_repo.by_ids(
          employee_ids_to_delete_account
        )

        script += remove_employees_script_generator.call(employees)
      end

      if index_numbers_to_delete_account &&
          !index_numbers_to_delete_account.empty?
        students = student_repo.by_index_numbers(
          index_numbers_to_delete_account
        )

        script += remove_students_script_generator.call(students)
      end

      if index_numbers_to_delete_database &&
          !index_numbers_to_delete_database.empty?
        students = student_repo.by_index_numbers(
          index_numbers_to_delete_database
        )

        script += delete_databases_script_generator.call(students)
      end

      script += <<~SCRIPT

        echo "SCRIPT EXECUTED SUCCESSFULLY";
      SCRIPT
    end
  end
end

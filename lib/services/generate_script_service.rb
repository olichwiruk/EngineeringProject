module Services
  class GenerateScriptService
    attr_reader :employee_repo, :student_repo,
      :add_employees_script_generator,
      :add_students_script_generator,
      :create_databases_script_generator

    def initialize(
      employee_repo,
      student_repo,
      add_employees_script_generator,
      add_students_script_generator,
      create_databases_script_generator
    )
      @employee_repo = employee_repo
      @student_repo = student_repo
      @add_employees_script_generator = add_employees_script_generator
      @add_students_script_generator = add_students_script_generator
      @create_databases_script_generator = create_databases_script_generator
    end

    def call(
      course_code:,
      employee_ids_to_create_account:,
      index_numbers_to_create_account:,
      index_numbers_to_create_database:
    )
      script = ''

      if employee_ids_to_create_account &&
          !employee_ids_to_create_account.empty?
        employees = employee_repo.by_ids(
          employee_ids_to_create_account
        )

        script += add_employees_script_generator.call(employees)
      end

      if index_numbers_to_create_account &&
          !index_numbers_to_create_account.empty?
        students = student_repo.by_index_numbers(
          index_numbers_to_create_account
        )

        script += add_students_script_generator.call(
          students, course_code
        )
      end

      if index_numbers_to_create_database &&
          !index_numbers_to_create_database.empty?
        students = student_repo.by_index_numbers(
          index_numbers_to_create_database
        )

        script += create_databases_script_generator.call(students)
      end

      script += <<~SCRIPT

        echo "SCRIPT EXECUTED SUCCESSFULLY";
      SCRIPT
    end
  end
end

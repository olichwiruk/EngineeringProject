module Services
  class GenerateScriptService
    attr_reader :student_repo,
      :add_students_script_generator,
      :create_databases_script_generator

    def initialize(
      student_repo,
      add_students_script_generator,
      create_databases_script_generator
    )
      @student_repo = student_repo
      @add_students_script_generator = add_students_script_generator
      @create_databases_script_generator = create_databases_script_generator
    end

    def call(
      course_code:,
      index_numbers_to_create_account:,
      index_numbers_to_create_database:
    )
      script = ''

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

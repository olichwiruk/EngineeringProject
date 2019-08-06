module Services
  class GenerateScriptService
    attr_reader :student_repo, :add_students_script_generator

    def initialize(
      student_repo,
      add_students_script_generator
    )
      @student_repo = student_repo
      @add_students_script_generator = add_students_script_generator
    end

    def call(params)
      script = ''

      if params['create-students-account'] &&
          !params['create-students-account'].empty?
        students = student_repo.by_index_numbers(
          params.fetch('create-students-account')
        )
        course_code = params.fetch('course-code')

        script += add_students_script_generator.call(
          students, course_code
        )
      end

      script += <<~SCRIPT
        echo "SCRIPT EXECUTED SUCCESSFULLY";
      SCRIPT
    end
  end
end

module Services
  class GenerateScriptService
    attr_reader :add_students_script_generator

    def initialize(
      add_students_script_generator
    )
      @add_students_script_generator = add_students_script_generator
    end

    def call(params)
      script = ''

      if params['create-students-account'] &&
          !params['create-students-account'].empty?
        script += add_students_script_generator.call(
          params['create-students-account']
        )
      end

      script
    end
  end
end

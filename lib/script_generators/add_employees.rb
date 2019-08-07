module ScriptGenerators
  class AddEmployees
    def call(employees)
      script = ''

      employees.each do |employee|
        script += <<~SCRIPT
          useradd -M #{employee.login} -p #{employee.password};
        SCRIPT
      end

      script
    end
  end
end

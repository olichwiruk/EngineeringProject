module ScriptGenerators
  class RemoveEmployees
    def call(employees)
      script = ''

      employees.each do |employee|
        script += <<~SCRIPT
          userdel #{employee.login};
        SCRIPT
      end

      script
    end
  end
end

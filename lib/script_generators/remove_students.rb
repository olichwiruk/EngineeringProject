module ScriptGenerators
  class RemoveStudents
    def call(students)
      script = ''

      students.each do |student|
        script += <<~SCRIPT
          userdel -r #{student.login};
        SCRIPT
      end

      script
    end
  end
end

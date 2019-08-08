module ScriptGenerators
  class AddStudents
    def call(students, course_code)
      script = <<~SCRIPT

        mkdir -p /home/#{course_code};
      SCRIPT

      students.each do |student|
        script += <<~SCRIPT
          useradd -m #{student.login} -b /home/#{course_code} -p #{student.password};
        SCRIPT
      end

      script
    end
  end
end

module ScriptGenerators
  class AddStudents
    def call(students, course_code)
      script = <<~SCRIPT
        mkdir -p /home/#{course_code};
      SCRIPT

      students.each do |student|
        script += <<~SCRIPT
          useradd -m s#{student.index_number} -b /home/#{course_code} -p #{student.surname.downcase + student.name.downcase};
        SCRIPT
      end

      script
    end
  end
end

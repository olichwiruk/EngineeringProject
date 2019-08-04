module Services
  class ImportService
    attr_reader :course_repo, :employee_repo, :student_repo

    def initialize(course_repo, employee_repo, student_repo)
      @course_repo = course_repo
      @employee_repo = employee_repo
      @student_repo = student_repo
    end

    def call(params)
      file_name = params.fetch('file-name')
      sheet = SheetManager.open(file_name)

      students = sheet.students.map do |student|
        ::Entities::Student.new(student)
      end

      instructor = ::Entities::Employee.new(sheet.instructor)

      course = ::Entities::Course.new(
        sheet.course.to_hash.merge(
          instructors: [instructor],
          students: students
        )
      )
      course_repo.save(course)
    end
  end
end

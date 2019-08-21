module Services
  class ImportService
    attr_reader :course_repo, :employee_repo, :student_repo

    def initialize(course_repo, employee_repo, student_repo)
      @course_repo = course_repo
      @employee_repo = employee_repo
      @student_repo = student_repo
    end

    def call(file_name)
      sheet = SheetManager.open(file_name)

      students = sheet.students.map do |student|
        ::Entities::Student.new(student)
      end
      created_students = student_repo.save_many(students)

      instructor = ::Entities::Employee.new(sheet.instructor)
      created_instructor = employee_repo.save(instructor)

      course = ::Entities::Course.new(
        sheet.course.to_hash.merge(
          instructors: [created_instructor],
          students: created_students
        )
      )
      course_repo.save(course)
    end
  end
end

module Services
  class AddInstructorToCourseService
    attr_reader :course_repo, :employee_repo

    def initialize(course_repo, employee_repo)
      @course_repo = course_repo
      @employee_repo = employee_repo
    end

    def call(employee_id, course_id)
      course = course_repo.by_id(course_id)
      employee = employee_repo.by_id(employee_id)

      course.add_instructor(employee)
      course_repo.save(course)
    end
  end
end

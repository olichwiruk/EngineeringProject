module Services
  class CourseService
    attr_reader :course_repo, :system_repo

    def initialize(course_repo, system_repo)
      @course_repo = course_repo
      @system_repo = system_repo
    end

    def call(course_id)
      course = find_course(course_id)
      [course, students_accounts(course.students)]
    end

    private def find_course(course_id)
      course_repo.by_id(course_id)
    end

    private def students_accounts(students)
      students.each_with_object({}) do |student, memo|
        memo[student.index_number.to_s] =
          system_users.include? "s#{student.index_number}"

        memo
      end
    end

    private def system_users
      @system_users ||= system_repo.all_users
    end
  end
end
module Services
  class CoursesService
    attr_reader :course_repo

    def initialize(course_repo)
      @course_repo = course_repo
    end

    def call
      course_repo.all.sort do |course1, course2|
        [
          course2.academic_year,
          course1.name_short,
          course1.group_number
        ] <=> [
          course1.academic_year,
          course2.name_short,
          course2.group_number
        ]
      end
    end
  end
end

module Services
  class StudentService
    attr_reader :repo

    def initialize(repo)
      @repo = repo
    end

    def call
      repo.students.to_a
    end
  end
end

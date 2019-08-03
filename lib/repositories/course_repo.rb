module Repositories
  class CourseRepo < ROM::Repository[:courses]
    auto_struct false

    def by_id(id)
      courses
        .where(id: id)
        .map_to(::Entities::Course)
        .one
    end
  end
end

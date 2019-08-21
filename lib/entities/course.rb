require 'entities/employee'
require 'entities/student'

module Entities
  class Course < ROM::Struct
    attribute :id, Types::Integer.meta(omittable: true)
    attribute :academy_unit, Types::String
    attribute :field_of_study, Types::String
    attribute :level_of_study, Types::String
    attribute :type_of_study, Types::String
    attribute :speciality, Types::Coercible::String
    attribute :academic_year, Types::String
    attribute :year_of_study, Types::Coercible::Integer
    attribute :semester_number, Types::Coercible::Integer
    attribute :semester_code, Types::String
    attribute :name, Types::String
    attribute :form_of_classes, Types::String
    attribute :form_of_passing, Types::String
    attribute :group, Types::String

    attribute :instructors, Types::Array(::Entities::Employee).meta(omittable: true)
    attribute :students, Types::Array(::Entities::Student).meta(omittable: true)

    def name_short
      name.split(' ').map(&:chr).join
    end

    def academy_unit_short
      academy_unit.split(' ').map(&:chr).join
    end

    def code
      name_short.downcase + academic_year[-2..-1]
    end

    def group_number
      group[-2..-1].to_i
    end

    def add_instructor(employee)
      instructors << employee
      instructors.uniq!
    end
  end
end

module Entities
  class Course < ROM::Struct
    attribute :id, Types::Integer
    attribute :academy_unit, Types::String
    attribute :field_of_study, Types::String
    attribute :level_of_study, Types::String
    attribute :type_of_study, Types::String
    attribute :speciality, Types::String
    attribute :academic_year, Types::String
    attribute :year_of_study, Types::Integer
    attribute :semester_number, Types::Integer
    attribute :semester_code, Types::String
    attribute :name, Types::String
    attribute :form_of_classes, Types::String
    attribute :form_of_passing, Types::String
    attribute :group, Types::String
  end
end

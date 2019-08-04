module Entities
  class Employee < ROM::Struct
    attribute :id, Types::Integer.meta(omittable: true)
    attribute :title, Types::String
    attribute :name, Types::String
    attribute :surname, Types::String
  end
end

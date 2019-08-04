module Entities
  class Student < ROM::Struct
    attribute :id, Types::Integer.meta(omittable: true)
    attribute :name, Types::String
    attribute :surname, Types::String
    attribute :index_number, Types::Coercible::Integer
  end
end

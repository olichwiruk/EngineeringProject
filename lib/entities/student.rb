module Entities
  class Student < ROM::Struct
    attribute :id, Types::Integer
    attribute :name, Types::String
    attribute :surname, Types::String
    attribute :index_number, Types::Integer
  end
end

module Entities
  class Employee < ROM::Struct
    attribute :id, Types::Integer
    attribute :title, Types::String
    attribute :name, Types::String
    attribute :surname, Types::String
  end
end
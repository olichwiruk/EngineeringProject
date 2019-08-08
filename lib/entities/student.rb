module Entities
  class Student < ROM::Struct
    attribute :id, Types::Integer.meta(omittable: true)
    attribute :name, Types::String
    attribute :surname, Types::String
    attribute :index_number, Types::Coercible::Integer

    def login
      "s#{index_number}"
    end

    def password
      (surname + name).downcase
    end
  end
end

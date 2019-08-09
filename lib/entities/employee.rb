module Entities
  class Employee < ROM::Struct
    attribute :id, Types::Integer.meta(omittable: true)
    attribute :title, Types::String
    attribute :name, Types::String
    attribute :surname, Types::String

    def login
      (name + surname).downcase
    end

    def password
      (surname + name).downcase
    end

    def full_name
      title + ' ' + name + ' ' + surname
    end
  end
end

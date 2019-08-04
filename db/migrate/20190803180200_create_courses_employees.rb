ROM::SQL.migration do
  change do
    create_table :courses_employees do
      foreign_key :course_id
      foreign_key :employee_id
    end
  end
end

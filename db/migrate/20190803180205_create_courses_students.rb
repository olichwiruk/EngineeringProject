ROM::SQL.migration do
  change do
    create_table :courses_students do
      foreign_key :course_id
      foreign_key :student_id
    end
  end
end

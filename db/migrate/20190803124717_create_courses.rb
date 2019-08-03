ROM::SQL.migration do
  change do
    create_table :courses do
      primary_key :id
      column :academy_unit, String
      column :field_of_study, String
      column :level_of_study, String
      column :type_of_study, String
      column :speciality, String
      column :academic_year, String
      column :year_of_study, Integer
      column :semester_number, Integer
      column :semester_code, String
      column :name, String
      column :form_of_classes, String
      column :form_of_passing, String
      column :group, String, null: false, uniqe: true
    end
  end
end

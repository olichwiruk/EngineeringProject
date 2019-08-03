ROM::SQL.migration do
  change do
    create_table :employees do
      primary_key :id
      column :title, String
      column :name, String, null: false
      column :surname, String, null: false
    end
  end
end

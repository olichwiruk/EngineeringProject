ROM::SQL.migration do
  change do
    create_table :students do
      primary_key :id
      column :name, String, null: false
      column :surname, String, null: false
      column :index_number, Integer, null:false, unique: true
    end
  end
end

ROM::SQL.migration do
  change do
    alter_table(:students) do
      add_index :index_number
    end
  end
end

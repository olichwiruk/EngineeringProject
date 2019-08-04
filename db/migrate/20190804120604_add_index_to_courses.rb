ROM::SQL.migration do
  change do
    alter_table(:courses) do
      add_index :group
    end
  end
end

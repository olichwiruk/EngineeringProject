module System
  class Repo
    attr_reader :sql_runner

    def initialize(sql_runner)
      @sql_runner = sql_runner
    end

    def all_users
      %x[cut -d: -f1 /etc/passwd].split(' ')
    end

    def all_databases
      sql_runner.run('show databases').split(' ').drop(1)
    end

    def employee_privilege_databases(employee)
      sql = <<~SQL
        SELECT table_schema
        FROM information_schema.schema_privileges
        WHERE grantee=\\\\\\\"'#{employee.login}'@'localhost'\\\\\\\"
        GROUP BY table_schema;
      SQL
      sql_runner.run(sql).split(' ').drop(1)
    end
  end
end

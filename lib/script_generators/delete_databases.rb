module ScriptGenerators
  class DeleteDatabases
    attr_reader :sql_runner

    def initialize(sql_runner)
      @sql_runner = sql_runner
    end

    def call(students)
      script = "\n"

      students.each do |student|
        sql_query = <<-SQL

          REVOKE ALL ON #{student.login}.*
          FROM #{database_privilege_users(student.login)} ;

          DROP DATABASE #{student.login};
        SQL

        script += <<~SCRIPT
          #{sql_runner.query(sql_query)}
        SCRIPT
      end

      script
    end

    private def database_privilege_users(db_name)
      sql_runner.run(
        <<-SQL
          SELECT grantee FROM information_schema.schema_privileges
          WHERE table_schema = \'#{db_name}\' GROUP BY grantee;
        SQL
      ).split(' ').drop(1).join(', ')
    end
  end
end

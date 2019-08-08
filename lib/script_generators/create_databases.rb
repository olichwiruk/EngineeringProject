module ScriptGenerators
  class CreateDatabases
    attr_reader :sql_runner

    def initialize(sql_runner)
      @sql_runner = sql_runner
    end

    def call(students)
      script = "\n"

      students.each do |student|
        sql_query = <<-SQL

          GRANT ALL ON #{student.login}.* TO '#{student.login}'@'localhost' IDENTIFIED BY '#{student.password}';
          CREATE DATABASE #{student.login};
        SQL

        script += <<~SCRIPT
          #{sql_runner.query(sql_query)}
        SCRIPT
      end

      script
    end
  end
end

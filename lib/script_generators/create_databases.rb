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

          GRANT ALL ON s#{student.index_number}.* TO 's#{student.index_number}'@'localhost' IDENTIFIED BY '#{student.surname.downcase + student.name.downcase}';
          CREATE DATABASE s#{student.index_number};
        SQL

        script += <<~SCRIPT
          #{sql_runner.query(sql_query)}
        SCRIPT
      end

      script
    end
  end
end

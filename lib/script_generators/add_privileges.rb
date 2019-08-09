module ScriptGenerators
  class AddPrivileges
    attr_reader :sql_runner

    def initialize(sql_runner)
      @sql_runner = sql_runner
    end

    def call(employee, students)
      script = "\n"

      students.each do |student|
        sql_query = <<-SQL

          GRANT ALL ON #{student.login}.* TO '#{employee.login}'@'localhost' IDENTIFIED BY '#{employee.password}';
        SQL

        script += <<~SCRIPT
          #{sql_runner.query(sql_query)}
        SCRIPT
      end

      script
    end
  end
end

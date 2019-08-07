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
  end
end

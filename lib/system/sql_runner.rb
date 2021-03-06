module System
  class SqlRunner
    attr_reader :config

    def initialize(config)
      @config = config['params']
    end

    def query(statement)
      "mysql -u #{config['username']} -p#{config['password']} -e \\\"#{statement}\\\";"
    end

    def run(statement)
      %x[echo "#{query(statement)}" | sudo su]
    end
  end
end

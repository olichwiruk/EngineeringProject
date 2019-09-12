module Services
  class ExecuteScriptService
    def call(script)
      %x(echo "#{script}" | sudo su)
    end
  end
end

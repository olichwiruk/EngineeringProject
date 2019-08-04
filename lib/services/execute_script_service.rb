module Services
  class ExecuteScriptService
    def call(script)
      %x(#{script})
    end
  end
end

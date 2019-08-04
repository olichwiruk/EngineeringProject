module ScriptGenerators
  class AddStudents
    def call(index_numbers)
      script = ''

      # index_numbers.each do |index_number|
        script += <<~SCRIPT
          cut -d: -f1 /etc/passwd
        SCRIPT
      # end

      script
    end
  end
end

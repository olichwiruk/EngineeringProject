class SheetManager
  attr_reader :sheet

  DATE_OF_GENERATION = 0
  ACADEMY_UNIT = 1
  FIELD_OF_STUDY = 2
  LEVEL_OF_STUDY = 3
  TYPE_OF_STUDY = 4
  SPECIALITY = 5
  ACADEMIC_YEAR = 6
  YEAR_OF_STUDY = 7
  SEMESTER_NUMBER = 8
  SEMESTER_CODE = 9
  COURSE_NAME = 10
  FORM_OF_CLASSES = 11
  FORM_OF_PASSING = 12
  GROUP = 13
  INSTRUCTOR = 14

  def initialize(sheet)
    @sheet = sheet
  end

  constants.each do |method|
    define_method(method.downcase) do
      sheet.row(
        Object.const_get("#{self.class.name}::#{method}")
      )[2]
    end
  end

  def students
    students = []
    sheet.rows[17..-1].each do |row|
      students << Student.new(name: row[1], index_number: row[2])
    end
    students
  end

  class Student
    attr_reader :name, :index_number

    def initialize(name:, index_number:)
      @name = name
      @index_number = index_number
    end
  end
end

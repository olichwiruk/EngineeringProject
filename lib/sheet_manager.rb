require 'spreadsheet'

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
  INSTRUCTOR_DATA = 14

  DIRECTORY = 'datafiles/'

  def initialize(sheet)
    @sheet = sheet
  end

  def self.open(file_name)
    new(
      Spreadsheet.open(DIRECTORY + file_name).worksheet(0)
    )
  end

  constants.each do |method|
    define_method(method.downcase) do
      sheet.row(
        Object.const_get("#{self.class.name}::#{method}")
      )[2]
    end
  end

  def course
    Course.new(
      academy_unit: academy_unit,
      field_of_study: field_of_study,
      level_of_study: level_of_study,
      type_of_study: type_of_study,
      speciality: speciality,
      academic_year: academic_year,
      year_of_study: year_of_study,
      semester_number: semester_number,
      semester_code: semester_code,
      name: course_name,
      form_of_classes: form_of_classes,
      form_of_passing: form_of_passing,
      group: group
    )
  end

  class Course
    attr_reader :academy_unit, :field_of_study, :level_of_study,
      :type_of_study, :speciality, :academic_year, :year_of_study,
      :semester_number, :semester_code, :name, :form_of_classes,
      :form_of_passing, :group

    def initialize(
      academy_unit:, field_of_study:, level_of_study:,
      type_of_study:, speciality:, academic_year:, year_of_study:,
      semester_number:, semester_code:, name:, form_of_classes:,
      form_of_passing:, group:
    )
      @academy_unit = academy_unit
      @field_of_study = field_of_study
      @level_of_study = level_of_study
      @type_of_study = type_of_study
      @speciality = speciality
      @academic_year = academic_year
      @year_of_study = year_of_study
      @semester_number = semester_number
      @semester_code = semester_code
      @name = name
      @form_of_classes = form_of_classes
      @form_of_passing = form_of_passing
      @group = group
    end

    def to_hash
      {
        academy_unit: academy_unit,
        field_of_study: field_of_study,
        level_of_study: level_of_study,
        type_of_study: type_of_study,
        speciality: speciality,
        academic_year: academic_year,
        year_of_study: year_of_study,
        semester_number: semester_number,
        semester_code: semester_code,
        name: name,
        form_of_classes: form_of_classes,
        form_of_passing: form_of_passing,
        group: group
      }
    end
  end

  def instructor
    data = instructor_data.split(' ')
    surname = data.pop
    name = data.pop
    title = data.join(' ')

    Instructor.new(
      title: title,
      name: name,
      surname: surname
    )
  end

  class Instructor
    attr_reader :title, :name, :surname

    def initialize(title:, name:, surname:)
      @title = title
      @name = name
      @surname = surname
    end

    def to_hash
      {
        title: title,
        name: name,
        surname: surname
      }
    end
  end

  def students
    students = []
    sheet.rows[17..-1].each do |row|
      next unless row[1] || row[2]

      surname, name = row[1].split(' ')
      index_number = row[2]
      students << Student.new(
        name: name, surname: surname, index_number: index_number
      )
    end
    students
  end

  class Student
    attr_reader :name, :surname, :index_number

    def initialize(name:, surname:, index_number:)
      @name = name
      @surname = surname
      @index_number = index_number
    end

    def to_hash
      {
        name: name,
        surname: surname,
        index_number: index_number
      }
    end
  end
end

require 'system/container'

db_config = YAML.load_file('config/database.yml')
config = ROM::Configuration.new(
  :sql,
  db_config['connection_url'],
  db_config['params']
)

Dir[File.join(LIB_PATH, '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'entities', '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'relations', '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'repositories', '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'script_generators', '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'services', '*.rb')].each { |file| require file }
Dir[File.join(LIB_PATH, 'system', '*.rb')].each { |file| require file }

Container.configure do |container|
  config.register_relation(Relations::Courses)
  config.register_relation(Relations::CoursesEmployees)
  config.register_relation(Relations::CoursesStudents)
  config.register_relation(Relations::Employees)
  config.register_relation(Relations::Students)
  rom = ROM.container(config)

  container.register(:course_repo) do
    Repositories::CourseRepo.new(rom)
  end

  container.register(:employee_repo) do
    Repositories::EmployeeRepo.new(rom)
  end

  container.register(:student_repo) do
    Repositories::StudentRepo.new(rom)
  end

  container.register(:system_repo) do
    System::Repo.new(container[:sql_runner])
  end

  container.register(:sql_runner) do
    System::SqlRunner.new(db_config)
  end

  container.register(:import_service) do
    Services::ImportService.new(
      container[:course_repo],
      container[:employee_repo],
      container[:student_repo]
    )
  end

  container.register(:courses_service) do
    Services::CoursesService.new(
      container[:course_repo]
    )
  end

  container.register(:course_service) do
    Services::CourseService.new(
      container[:course_repo],
      container[:employee_repo],
      container[:system_repo]
    )
  end

  container.register(:generate_create_script_service) do
    Services::GenerateCreateScriptService.new(
      container[:employee_repo],
      container[:student_repo],
      container[:add_employees_script_generator],
      container[:add_students_script_generator],
      container[:create_databases_script_generator],
      container[:add_privileges_script_generator]
    )
  end

  container.register(:generate_delete_script_service) do
    Services::GenerateDeleteScriptService.new(
      container[:employee_repo],
      container[:student_repo],
      container[:remove_employees_script_generator],
      container[:remove_students_script_generator],
      container[:delete_databases_script_generator]
    )
  end

  container.register(:execute_script_service) do
    Services::ExecuteScriptService.new
  end

  container.register(:add_instructor_to_course_service) do
    Services::AddInstructorToCourseService.new(
      container[:course_repo],
      container[:employee_repo]
    )
  end

  container.register(:create_employee_service) do
    Services::CreateEmployeeService.new(
      container[:employee_repo]
    )
  end

  container.register(:add_employees_script_generator) do
    ScriptGenerators::AddEmployees.new
  end

  container.register(:add_students_script_generator) do
    ScriptGenerators::AddStudents.new
  end

  container.register(:create_databases_script_generator) do
    ScriptGenerators::CreateDatabases.new(
      container[:sql_runner]
    )
  end

  container.register(:add_privileges_script_generator) do
    ScriptGenerators::AddPrivileges.new(
      container[:sql_runner]
    )
  end

  container.register(:remove_employees_script_generator) do
    ScriptGenerators::RemoveEmployees.new
  end

  container.register(:remove_students_script_generator) do
    ScriptGenerators::RemoveStudents.new
  end

  container.register(:delete_databases_script_generator) do
    ScriptGenerators::DeleteDatabases.new(
      container[:sql_runner]
    )
  end
end

Container.finalize

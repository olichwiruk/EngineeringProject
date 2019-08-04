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
    System::Repo.new
  end

  container.register(:import_service) do
    Services::ImportService.new(
      container[:course_repo],
      container[:employee_repo],
      container[:student_repo]
    )
  end

  container.register(:course_service) do
    Services::CourseService.new(
      container[:course_repo],
      container[:system_repo]
    )
  end

  container.register(:generate_script_service) do
    Services::GenerateScriptService.new(
      container[:add_students_script_generator]
    )
  end

  container.register(:execute_script_service) do
    Services::ExecuteScriptService.new
  end

  container.register(:add_students_script_generator) do
    ScriptGenerators::AddStudents.new
  end
end

Container.finalize

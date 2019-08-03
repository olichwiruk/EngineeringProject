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
Dir[File.join(LIB_PATH, 'services', '*.rb')].each { |file| require file }

Container.configure do |container|
  config.register_relation(Relations::Courses)
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

  container.register(:service) do
    Services::StudentService.new(
      container[:student_repo]
    )
  end
end

Container.finalize
require './application'
require './plugins/authenticator'

class Web < Application
  use RequestMiddleware
  plugin :render
  plugin :authenticator

  configure do |config|
    config.container = Container.instance
  end

  route do |r|
    r.authenicate do
      r.root do
        r.redirect('courses')
      end

      r.on 'import' do
        r.post do
          r.resolve :import_service do |service|
            file_name = r.params.fetch('file-name')
            course = service.call(file_name)
            r.redirect("courses/#{course.id}")
          end
        end
      end

      r.on 'courses' do
        r.get Integer do |course_id|
          r.resolve :course_service do |service|
            course,
              students_data,
              instructors_data,
              rest_employees = service.call(course_id)

            view(
              'course',
              locals: {
                course: course,
                students_system_data: students_data,
                instructors_system_data: instructors_data,
                rest_employees: rest_employees
              }
            )
          end
        end

        r.post 'add_instructor' do
          params = JSON.parse(r.body.read)
          instructor_id = params.fetch('instructor_id').to_i
          course_id = params.fetch('course_id').to_i

          r.resolve :add_instructor_to_course_service do |service|
            service.call(instructor_id, course_id)
          end

          r.redirect("courses/#{course_id}")
        end

        r.get do
          r.resolve :courses_service do |service|
            courses = service.call

            view(
              'courses',
              locals: {
                courses: courses
              }
            )
          end
        end
      end

      r.on 'employees' do
        r.get 'new' do
          course_id = r.params.fetch('course_id') do
            r.redirect('/')
          end

          view(
            'new_employee',
            locals: {
              course_id: course_id
            }
          )
        end

        r.post do
          course_id = r.params.fetch('course_id')
          title = r.params.fetch('title')
          name = r.params.fetch('name')
          surname = r.params.fetch('surname')

          r.resolve :create_employee_service do |create_employee|
            employee = create_employee.call(title, name, surname)

            if employee
              r.resolve :add_instructor_to_course_service do |add_instructor|
                add_instructor.call(employee.id, course_id)
              end
            end
          end

          r.redirect("courses/#{course_id}")
        end
      end

      r.on 'script' do
        r.post do
          create_script = ''
          delete_script = ''

          r.resolve :generate_create_script_service do |service|
            create_script = service.call(
              course_code: r.params['course-code'],
              employee_ids_to_create_account: r.params['create-instructors-account'],
              index_numbers_to_create_account: r.params['create-students-account'],
              index_numbers_to_create_database: r.params['create-students-db'],
              employee_id_to_add_privileges: r.params['instructor-db'],
              index_numbers_to_add_privileges: r.params['add-privileges-db']
            )
          end

          r.resolve :generate_delete_script_service do |service|
            delete_script = service.call(
              employee_ids_to_delete_account: r.params['delete-instructors-account'],
              index_numbers_to_delete_account: r.params['delete-students-account'],
              index_numbers_to_delete_database: r.params['delete-students-db']
            )
          end

          view('script', locals: {
            create_script: create_script,
            delete_script: delete_script
          })
        end
      end

      r.post 'execute' do
        r.resolve :execute_script_service do |service|
          script = r.params.fetch('script').gsub(/\s+/, ' ')
          result = service.call(script)

          view('script_execute', locals: { result: result })
        end
      end
    end
  end
end

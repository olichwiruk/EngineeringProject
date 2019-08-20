require './application'

class Web < Application
  use RequestMiddleware
  plugin :render

  configure do |config|
    config.container = Container.instance
  end

  route do |r|
    r.root do
      r.redirect('import')
    end

    r.on 'import' do
      r.get do
        view('import')
      end

      r.post do
        r.resolve :import_service do |service|
          course = service.call(r.params)
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
        r.resolve :add_instructor_to_course_service do |service|
          params = JSON.parse(r.body.read)
          instructor_id = params.fetch('instructor_id').to_i
          course_id = params.fetch('course_id').to_i

          service.call(instructor_id, course_id)

          r.redirect("courses/#{course_id}")
        end
      end
    end

    r.on 'script' do
      r.post do
        r.resolve :generate_script_service do |service|
          script = service.call(
            course_code: r.params['course-code'],
            employee_ids_to_create_account: r.params['create-instructors-account'],
            index_numbers_to_create_account: r.params['create-students-account'],
            index_numbers_to_create_database: r.params['create-students-db'],
            employee_id_to_add_privileges: r.params['instructor-db'],
            index_numbers_to_add_privileges: r.params['add-privileges-db']
          )
          view('script', locals: { script: script })
        end
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

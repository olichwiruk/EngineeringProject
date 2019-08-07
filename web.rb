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
          course, students_data, employees_data = service.call(course_id)

          view(
            'course',
            locals: {
              course: course,
              students_system_data: students_data,
              employees_system_data: employees_data
            }
          )
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
            index_numbers_to_create_database: r.params['create-students-db']
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

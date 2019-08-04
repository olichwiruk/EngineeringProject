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
          course, students_accounts = service.call(course_id)

          view(
            'course',
            locals: {
              course: course,
              students_system_accounts: students_accounts
            }
          )
        end
      end
    end

    r.on 'script' do
      r.post do
      end
    end
  end
end

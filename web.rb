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
          service.call(r.params)
        end

        file_name = r.params.fetch('file-name')
        sheet = SheetManager.open(file_name)
        view('index', locals: { sheet: sheet })
      end
    end
  end
end

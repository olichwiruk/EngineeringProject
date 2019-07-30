require './application'
require 'spreadsheet'

class Web < Application
  use RequestMiddleware
  plugin :render

  configure do |config|
    config.container = Container.instance
  end

  route do |r|
    r.root do
      r.resolve :service do |service|
        service
      end

      file_name = 'file.xls'
      sheet = SheetManager.new(
        Spreadsheet.open('datafiles/' + file_name).worksheet(0)
      )
      @users = %x(cut -d: -f1 /etc/passwd)
      view('index', locals: { sheet: sheet })
    end
  end
end

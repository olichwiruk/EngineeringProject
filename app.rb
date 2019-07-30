require 'roda'
require 'spreadsheet'

class App < Roda
  plugin :render

  route do |r|
    r.root do
      file_name = 'file.xls'
      sheet = SheetManager.new(
        Spreadsheet.open('datafiles/' + file_name).worksheet(0)
      )
      @users = %x(cut -d: -f1 /etc/passwd)
      view('index', locals: { sheet: sheet })
    end
  end
end

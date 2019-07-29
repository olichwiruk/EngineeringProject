require 'roda'
require 'spreadsheet'

class App < Roda
  plugin :render

  route do |r|
    r.root do
      file_path = 'file.xls'
      sheet = SheetManager.new(
        Spreadsheet.open(file_path).worksheet(0)
      )
      view('index', locals: { sheet: sheet })
    end
  end
end

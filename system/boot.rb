require './system/container'

Container.configure do |container|
  container.register(:service) do
    'asd'
  end
end

Container.finalize

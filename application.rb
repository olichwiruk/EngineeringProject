require 'roda'
require 'roda/plugins/flow'

class Application < Roda
  extend Dry::Configurable
  setting :container, reader: true

  plugin :flow

  def self.resolve(name)
    container[name]
  end
end

class RequestMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end

require 'dry-container'

class Container
  class Container
    include Dry::Container::Mixin
  end

  attr_reader :container

  class << self
    attr_reader :container
    attr_reader :instance
  end

  def self.configure
    @container ||= Container.new

    yield(container)

    @instance ||= new(container)
  end

  def self.finalize
    instance.freeze
  end

  def initialize(container)
    @container = container
  end

  def [](name)
    container[name]
  end
end

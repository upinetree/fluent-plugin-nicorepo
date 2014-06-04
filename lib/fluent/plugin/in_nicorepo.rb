require 'nicorepo'

module Fluent
  class NicorepoInput < Fluent::Input
    Plugin.register_input 'nicorepo', self

    config_param :tag, :string

    def configure(conf)
      @interval = 3
      super
    end

    def start
      @thread = Thread.new(&method(:run))
      super
    end

    def shutdown
      super
    end

    def run
      loop do
        Thread.new(&method(:run))
        sleep @interval
      end
    end

    def run
      time = Time.now.to_s
      record = "hoge"
      Engine.emit(tag, time, record)
    rescue => e
      log.error "unexpected error", error: e
    end
  end
end


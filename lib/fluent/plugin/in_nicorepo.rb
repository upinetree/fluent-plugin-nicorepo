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
      Thread.kill(@thread)
      super
    end

    def run
      loop do
        Thread.new(&method(:on_timer))
        sleep @interval
      end
    end

    def on_timer
      time = Time.now
      record = "hoge"
      Engine.emit(@tag, time, record)
    rescue => e
      log.error "unexpected error", error: e
    end
  end
end


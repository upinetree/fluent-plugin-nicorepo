require 'nicorepo'
require "fluent/input"

module Fluent
  class NicorepoInput < Fluent::Input
    Plugin.register_input("nicorepo", self)

    desc 'The tag of the event'
    config_param :tag, :string
    desc 'The interval of each fetching'
    config_param :interval, :time, default: 600
    desc 'Max logs number at once fetch'
    config_param :limit_num, :integer, default: 50
    desc 'Max pages number at once fetch'
    config_param :limit_page, :integer, default: 30
    desc 'Acceptable log kind for the log filter'
    config_param :kind, :string, default: 'all'

    def configure(conf)
      @client = Nicorepo::Client.new
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

      fetch_report.format.each do |log|
        router.emit(@tag, time, log)
      end
    rescue => e
      log.error "unexpected error", error: e
    end

    private

    def fetch_report
      last_fetched_at = Time.now - @interval

      case @kind
      when 'all'
        @client.all(@limit_num, to: last_fetched_at)
      when 'videos'
        @client.videos(@limit_num, limit_page: @limit_page, to: last_fetched_at)
      when 'lives'
        @client.lives(@limit_num, limit_page: @limit_page, to: last_fetched_at)
      else
        log.error "unsupported report kind: #{@kind}"
        []
      end
    end
  end
end

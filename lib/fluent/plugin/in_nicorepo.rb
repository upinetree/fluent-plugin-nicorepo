require 'nicorepo'
require "fluent/input"

module Fluent
  class NicorepoInput < Fluent::Input
    Plugin.register_input("nicorepo", self)

    desc 'The tag of the event'
    config_param :tag, :string
    desc 'The login main address for nicovideo'
    config_param :mail, :string
    desc 'The login password for nicovideo'
    config_param :pass, :string
    desc 'The interval of each fetching'
    config_param :interval, :time, default: 600
    desc 'Max logs number at once fetch'
    config_param :limit_num, :integer, default: 50
    desc 'Max pages number at once fetch'
    config_param :limit_page, :integer, default: 30
    desc 'Acceptable log kind for the log filter'
    config_param :kind, :string, default: 'all'

    def configure(conf)
      @nicorepo = Nicorepo.new
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
      reports = fetch_reports
      reports.each do |report|
        time = Time.now
        record = report_to_hash(report)
        router.emit(@tag, time, record)
      end
    rescue => e
      log.error "unexpected error", error: e
    end

    private

    def fetch_reports
      since = Time.now - @interval
      @nicorepo.login(@mail, @pass)

      case @kind
      when 'all'
        @nicorepo.all(@limit_num, since: since)
      when 'videos'
        @nicorepo.videos(@limit_num, @limit_page, since: since)
      when 'lives'
        @nicorepo.lives(@limit_num, @limit_page, since: since)
      else
        log.error "unsupported report kind: #{@kind}"
        []
      end
    end

    def report_to_hash(report)
      {
        'body'  => report.body,
        'title' => report.title,
        'url'   => report.url,
        'date'  => report.date
      }
    end
  end
end

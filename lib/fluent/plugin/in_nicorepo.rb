require 'nicorepo'

module Fluent
  class NicorepoInput < Fluent::Input
    Plugin.register_input 'nicorepo', self

    config_param :tag, :string
    config_param :interval, :time, default: '10m'
    config_param :mail, :string
    config_param :pass, :string

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
        record = parse_report(report)
        Engine.emit(@tag, time, record)
      end
    rescue => e
      log.error "unexpected error", error: e
    end

    private

    def fetch_reports
      @nicorepo.login(@mail, @pass)
      @nicorepo.all(3, since: nil)
    end

    def parse_report(report)
      {
        body:  report.body,
        title: report.title,
        url:   report.url,
        date:  report.date
      }
    end
  end
end

